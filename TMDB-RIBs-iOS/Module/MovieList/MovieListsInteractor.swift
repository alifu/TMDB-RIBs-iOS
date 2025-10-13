//
//  MovieListsInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 02/10/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol MovieListsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MovieListsPresentable: Presentable {
    var listener: MovieListsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindMovieLists(_ data: Observable<[TheMovieLists.Tab]>)
    func bindMovies(_ data: Observable<[TheMovieLists.Wrapper]>)
    func loading(_ isLoading: Observable<Bool>)
}

protocol MovieListsListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didSelectMovie(_ movie: TheMovieLists.Wrapper)
    func didUpdateHeight(with height: CGFloat)
}

final class MovieListsInteractor: PresentableInteractor<MovieListsPresentable>, MovieListsInteractable, MovieListsPresentableListener {
    
    weak var router: MovieListsRouting?
    weak var listener: MovieListsListener?
    private let apiManager: APIManager
    private var movieLists: BehaviorRelay<[TheMovieLists.Tab]> = .init(value: theMovieLists)
    private var movieListData = theMovieLists
    private var movies: BehaviorRelay<[TheMovieLists.Wrapper]> = .init(value: [])
    private let loadMoreTrigger: PublishRelay<Void>
    private let isLoadingRelay: BehaviorRelay<Bool>
    
    private var activeTabRelay: BehaviorRelay<MovieListsType> = .init(value: .nowPlaying)
    private var currentPageRelay: BehaviorRelay<[MovieListsType: Int]> = .init(value: [
        .nowPlaying: 1,
        .upcoming: 1,
        .topRated: 1,
        .popular: 1
    ])
    private var totalPagesRelay: BehaviorRelay<[MovieListsType: Int]> = .init(value: [
        .nowPlaying: 0,
        .upcoming: 0,
        .topRated: 0,
        .popular: 0
    ])
    private var nowPlayingResponse: [TheMovieNowPlaying.Result] = []
    private var upComingResponse: [TheMovieUpComing.Result] = []
    private var topRatedResponse: [TheMovieTopRated.Result] = []
    private var popularResponse: [TheMoviePopular.Result] = []
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MovieListsPresentable,
        apiManager: APIManager,
        dependecy: MovieListsDependency
    ) {
        self.isLoadingRelay = dependecy.isLoadingRelay
        self.loadMoreTrigger = dependecy.loadMoreTrigger
        self.apiManager = apiManager
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        bindInitialLoading()
        self.presenter.bindMovieLists(movieLists.asObservable())
        self.presenter.bindMovies(movies.asObservable())
        bindLoadMore()
        fetchNowPlayingMovies()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didSelectMovieList(_ indexPath: IndexPath, item: TheMovieLists.Tab) {
        movieListData.select(id: item.id)
        movieLists.accept(movieListData)
        activeTabRelay.accept(item.type)
        switch item.type {
        case .nowPlaying:
            if !nowPlayingResponse.isEmpty {
                let data = nowPlayingResponse.map { $0.toWrapper() }
                self.movies.accept(data)
                return
            }
            fetchNowPlayingMovies()
        case .upcoming:
            if !upComingResponse.isEmpty {
                let data = upComingResponse.map { $0.toWrapper() }
                self.movies.accept(data)
                return
            }
            fetchUpComingMovies()
        case .topRated:
            if !topRatedResponse.isEmpty {
                let data = topRatedResponse.map { $0.toWrapper() }
                self.movies.accept(data)
                return
            }
            fetchTopRatedMovies()
        case .popular:
            if !popularResponse.isEmpty {
                let data = popularResponse.map { $0.toWrapper() }
                self.movies.accept(data)
                return
            }
            fetchPopularMovies()
        }
    }
    
    func didSelectMovie(_ indexPath: IndexPath, item: TheMovieLists.Wrapper) {
        self.listener?.didSelectMovie(item)
    }
    
    func didUpdateHeight(with height: CGFloat) {
        self.listener?.didUpdateHeight(with: height)
    }
    
    // MARK: - Private
    
    private func bindInitialLoading() {
        Observable
            .combineLatest(
                isLoadingRelay.distinctUntilChanged(),
                activeTabRelay.distinctUntilChanged(),
                currentPageRelay
            )
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading, activeTab, currentPages in
                guard let self else { return }
                
                // get current page for active tab
                let currentPage = currentPages[activeTab] ?? 0
                
                if isLoading && currentPage == 1 {
                    // show loader for first page of this tab
                    self.listener?.didUpdateHeight(with: 400)
                    self.presenter.loading(.just(true))
                } else if !isLoading {
                    // hide loader when loading stops
                    self.presenter.loading(.just(false))
                }
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func updateTotalPages(for type: MovieListsType, total: Int) {
        var totals = totalPagesRelay.value
        totals[type] = total
        totalPagesRelay.accept(totals)
    }
    
    private func incrementPage(for type: MovieListsType) {
        var current = currentPageRelay.value
        let nextPage = (current[type] ?? 1) + 1
        current[type] = nextPage
        currentPageRelay.accept(current)
    }
    
    private func currentPage(for type: MovieListsType) -> Int {
        return currentPageRelay.value[type] ?? 1
    }
    
    private func bindLoadMore() {
        loadMoreTrigger
            .withLatestFrom(Observable.combineLatest(isLoadingRelay, activeTabRelay, currentPageRelay, totalPagesRelay))
            .filter { isLoading, activeTab, currentPages, totalPages in
                // must not be loading
                guard !isLoading else { return false }
                // get current and total for active tab
                let current = currentPages[activeTab] ?? 1
                let total = totalPages[activeTab] ?? 0
                // only allow loadMore if we haven’t reached the end
                return total == 0 || current < total
            }
            .map { _, activeTab, _, _ in activeTab }
            .subscribe(onNext: { [weak self] activeTab in
                guard let `self` = self else { return }
                switch activeTab {
                case .nowPlaying:
                    self.fetchNowPlayingMovies()
                case .upcoming:
                    self.fetchUpComingMovies()
                    break
                case .topRated:
                    self.fetchTopRatedMovies()
                    break
                case .popular:
                    self.fetchPopularMovies()
                    break
                }
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchNowPlayingMovies() {
        isLoadingRelay.accept(true)
        let request = TheMovieNowPlaying.Request(page: currentPage(for: .nowPlaying), language: "en_US")
        apiManager.fetchNowPlayingMovie(request: request).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                defer {
                    self.isLoadingRelay.accept(false)
                }
                if response.results.isEmpty { return }
                self.nowPlayingResponse.append(contentsOf: response.results)
                self.incrementPage(for: .nowPlaying)
                self.updateTotalPages(for: .nowPlaying, total: response.totalPages)
                
                let newItems = nowPlayingResponse.map { $0.toWrapper() }
                var seen = Set<Int>()
                let combined = newItems
                    .filter { seen.insert($0.id).inserted }
                self.movies.accept(combined)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoadingRelay.accept(false)
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchUpComingMovies() {
        isLoadingRelay.accept(true)
        let request = TheMovieUpComing.Request(page: currentPage(for: .upcoming), language: "en_US")
        apiManager.fetchUpComingMovie(request: request).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                defer { self.isLoadingRelay.accept(false) }
                if response.results.isEmpty { return }
                self.upComingResponse.append(contentsOf: response.results)
                self.incrementPage(for: .upcoming)
                self.updateTotalPages(for: .upcoming, total: response.totalPages)
                
                let newItems = upComingResponse.map { $0.toWrapper() }
                var seen = Set<Int>()
                let combined = newItems
                    .filter { seen.insert($0.id).inserted }
                self.movies.accept(combined)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoadingRelay.accept(false)
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchTopRatedMovies() {
        isLoadingRelay.accept(true)
        let request = TheMovieTopRated.Request(page: currentPage(for: .topRated), language: "en_US")
        apiManager.fetchTopRatedMovie(request: request).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                defer { self.isLoadingRelay.accept(false) }
                if response.results.isEmpty { return }
                self.topRatedResponse.append(contentsOf: response.results)
                self.incrementPage(for: .topRated)
                self.updateTotalPages(for: .topRated, total: response.totalPages)
                
                let newItems = topRatedResponse.map { $0.toWrapper() }
                var seen = Set<Int>()
                let combined = newItems
                    .filter { seen.insert($0.id).inserted }
                self.movies.accept(combined)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoadingRelay.accept(false)
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchPopularMovies() {
        isLoadingRelay.accept(true)
        let request = TheMoviePopular.Request(page: currentPage(for: .popular), language: "en_US")
        apiManager.fetchPopularMovie(request: request).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                defer { self.isLoadingRelay.accept(false) }
                if response.results.isEmpty { return }
                self.popularResponse.append(contentsOf: response.results)
                self.incrementPage(for: .popular)
                self.updateTotalPages(for: .popular, total: response.totalPages)
                
                let newItems = popularResponse.map { $0.toWrapper() }
                var seen = Set<Int>()
                let combined = newItems
                    .filter { seen.insert($0.id).inserted }
                self.movies.accept(combined)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoadingRelay.accept(false)
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
}
