//
//  MovieDetailInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import RIBs
import RxCocoa
import RxSwift

protocol MovieDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachMovieDetailInfoChild(apiManager: APIManager, withId: Int) -> MovieDetailInfoInteractable?
    func detachMovieDetailInfo()
}

protocol MovieDetailPresentable: Presentable {
    var listener: MovieDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindContent(with detail: Observable<TheMovieDetail.Response>)
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
    private var movieDetailData = PublishRelay<TheMovieDetail.Response>()
    private var isLoading = PublishRelay<Bool>()
    private var aboutMovieRelay: BehaviorRelay<String?>
    private var isWatchList: BehaviorRelay<Bool> = .init(value: false)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MovieDetailPresentable,
        dependency: MovieDetailInfoDependency,
        apiManager: APIManager,
        withMovieId: Int
    ) {
        self.apiManager = apiManager
        self.withMovieId = withMovieId
        self.aboutMovieRelay = dependency.aboutMovieRelay
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.loading(isLoading.asObservable())
        self.presenter.bindContent(with: movieDetailData.asObservable())
        self.presenter.bindWatchListButton(with: isWatchList.asObservable())
        fetchMovieDetail()
        attacMovieInfo()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchMovieDetail() {
        isLoading.accept(true)
        apiManager.fetchMovieDetailWithStates(id: withMovieId).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                self.aboutMovieRelay.accept(response.overview)
                self.movieDetailData.accept(response)
                self.isWatchList.accept(response.accountStates?.watchlist ?? false)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                print("❌ API Error:", error)
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
    
    private func attacMovieInfo() {
        if let child = router?.attachMovieDetailInfoChild(apiManager: apiManager, withId: withMovieId) {
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
}
