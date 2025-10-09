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
}

protocol MovieListsListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didSelectMovie(_ movie: TheMovieLists.Wrapper)
}

final class MovieListsInteractor: PresentableInteractor<MovieListsPresentable>, MovieListsInteractable, MovieListsPresentableListener {

    weak var router: MovieListsRouting?
    weak var listener: MovieListsListener?
    private let apiManager: APIManager
    private var movieLists: BehaviorRelay<[TheMovieLists.Tab]> = .init(value: theMovieLists)
    private var movieListData = theMovieLists
    private var movies: BehaviorRelay<[TheMovieLists.Wrapper]> = .init(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MovieListsPresentable,
        apiManager: APIManager
    ) {
        self.apiManager = apiManager
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.bindMovieLists(movieLists.asObservable())
        self.presenter.bindMovies(movies.asObservable())
        fetchNowPlayingMovies()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didSelectMovieList(_ indexPath: IndexPath, item: TheMovieLists.Tab) {
        movieListData.select(id: item.id)
        movieLists.accept(movieListData)
        switch item.type {
        case .nowPlaying:
            fetchNowPlayingMovies()
        case .upcoming:
            fetchUpComingMovies()
        case .topRated:
            fetchTopRatedMovies()
        case .popular:
            fetchPopularMovies()
        }
    }
    
    func didSelectMovie(_ indexPath: IndexPath, item: TheMovieLists.Wrapper) {
        self.listener?.didSelectMovie(item)
    }
    
    // MARK: - Private
    
    private func fetchNowPlayingMovies() {
        let request = TheMovieNowPlaying.Request(page: 1, language: "en_US")
        apiManager.fetchNowPlayingMovie(request: request, isLocal: true).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                let data = response.results.map { $0.toWrapper() }
                self.movies.accept(data)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchUpComingMovies() {
        let request = TheMovieUpComing.Request(page: 1, language: "en_US")
        apiManager.fetchUpComingMovie(request: request, isLocal: true).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                let data = response.results.map { $0.toWrapper() }
                self.movies.accept(data)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchTopRatedMovies() {
        let request = TheMovieTopRated.Request(page: 1, language: "en_US")
        apiManager.fetchTopRatedMovie(request: request, isLocal: true).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                let data = response.results.map { $0.toWrapper() }
                self.movies.accept(data)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchPopularMovies() {
        let request = TheMoviePopular.Request(page: 1, language: "en_US")
        apiManager.fetchPopularMovie(request: request, isLocal: true).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                let data = response.results.map { $0.toWrapper() }
                self.movies.accept(data)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
}
