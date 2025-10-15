//
//  MovieDetailInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol MovieDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachMovieDetailInfoChild(apiManager: APIManager, withId: Int) -> MovieDetailInfoInteractable?
    func detachMovieDetailInfo()
    func attachCarouselChild() -> CarouselMovieInteractable?
    func detachCarousel()
    func attachWebPlayerChild(withURL url: URL) -> WebPlayerInteractable?
    func detachWebPlayer()
}

protocol MovieDetailPresentable: Presentable {
    var listener: MovieDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindContent(with detail: Observable<TheMovieDetail.Response?>)
    func bindWatchListButton(with: Observable<Bool>)
    func loading(_ isLoading: Observable<Bool>)
}

protocol MovieDetailListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func goBackFromMovieDetail()
}

final class MovieDetailInteractor: PresentableInteractor<MovieDetailPresentable>, MovieDetailInteractable, MovieDetailPresentableListener {
    
    weak var router: MovieDetailRouting?
    weak var listener: MovieDetailListener?
    private let apiManager: APIManager
    private let withMovieId: Int
    private let movieInfoRelay = BehaviorRelay<TheMovieDetail.Response?>(value: nil)
    private let accountStateRelay = BehaviorRelay<TheMovieAccountStates.Response?>(value: nil)
    private let videosRelay = BehaviorRelay<[TheMovieVideo.Result]>(value: [])
    private var isLoading = PublishRelay<Bool>()
    private var aboutMovieRelay: BehaviorRelay<String?>
    private var isWatchList: BehaviorRelay<Bool> = .init(value: false)
    private let carouselMovieItems: BehaviorRelay<[TheMovieCaraousel]>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MovieDetailPresentable,
        dependencyInfo: MovieDetailInfoDependency,
        dependencyCarousel: CarouselMovieDependency,
        apiManager: APIManager,
        withMovieId: Int
    ) {
        self.apiManager = apiManager
        self.withMovieId = withMovieId
        self.aboutMovieRelay = dependencyInfo.aboutMovieRelay
        self.carouselMovieItems = dependencyCarousel.carouselMovieItems
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.loading(isLoading.asObservable())
        self.presenter.bindContent(with: movieInfoRelay.asObservable())
        self.presenter.bindWatchListButton(with: isWatchList.asObservable())
        attachCarousel()
        fetchMovieDetail()
        attacMovieInfo()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchMovieDetail() {
        isLoading.accept(true)
        
        apiManager.fetchMovieDetailWithStates(id: withMovieId)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] response in
                    guard let `self` = self else { return }
                    self.isLoading.accept(false)
                    
                    // Update UI with available data
                    // First emission (detail only)
                    if self.movieInfoRelay.value == nil {
                        self.movieInfoRelay.accept(response)
                        self.aboutMovieRelay.accept(response.overview)
                        self.accountStateRelay.accept(response.accountStates)
                        self.videosRelay.accept(response.videos?.results ?? [])
                        self.isWatchList.accept(response.accountStates?.watchlist ?? false)
                        self.collectingTheCarousel(backdropEmpty: true)
                    } else {
                        // Update incremental parts only
                        if let accountStates = response.accountStates {
                            self.accountStateRelay.accept(accountStates)
                            self.isWatchList.accept(accountStates.watchlist)
                        }
                        if let videos = response.videos {
                            self.videosRelay.accept(videos.results)
                            self.collectingTheCarousel(backdropEmpty: false)
                        }
                    }
                    
                    // Debug
                    print("🎬 Movie detail updated — videos:", response.videos?.results.count ?? 0)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoading.accept(false)
                    print("❌ API Error:", error)
                },
                onCompleted: {
                    print("✅ Finished fetching movie detail + states + videos")
                }
            )
            .disposeOnDeactivate(interactor: self)
    }
    
    private func postWatchList() {
        let request = TheMovieWatchListPost.Request(mediaType: "movie", mediaId: withMovieId, watchlist: !isWatchList.value)
        apiManager.postWatchList(request: request).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                let nextStatus = response.success ? !isWatchList.value : isWatchList.value
                self.isWatchList.accept(nextStatus)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func collectingTheCarousel(backdropEmpty: Bool) {
        if backdropEmpty {
            let backdrop = movieInfoRelay.value?.backdropPath ?? ""
            carouselMovieItems.accept([.backdrop(URL(string: "\(Natrium.Config.baseImageW500Url)\(backdrop)"))])
        } else {
            let limitedVideos = videosRelay.value.prefix(6)
            var currentValue = carouselMovieItems.value
            currentValue.append(contentsOf: limitedVideos.map { .video($0) })
            carouselMovieItems.accept(currentValue)
        }
    }
    
    private func attacMovieInfo() {
        if let child = self.router?.attachMovieDetailInfoChild(apiManager: apiManager, withId: withMovieId) {
            child.listener = self
        }
    }
    
    private func attachCarousel() {
        if let child = self.router?.attachCarouselChild() {
            child.listener = self
        }
    }
}

extension MovieDetailInteractor {
    
    func goBack() {
        self.listener?.goBackFromMovieDetail()
    }
    
    func didClickSaveButton() {
        postWatchList()
    }
    
    func openVideoWith(url: URL) {
        if let child = self.router?.attachWebPlayerChild(withURL: url) {
            child.listener = self
        }
    }
    
    func goBackFromWebPlayer() {
        self.router?.detachWebPlayer()
    }
}
