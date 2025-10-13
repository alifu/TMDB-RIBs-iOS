//
//  HomeInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol HomeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachFeaturedMovieChild(apiManager: APIManager) -> FeaturedMovieInteractable?
    func detachFeaturedMovie()
    func attachMovieListsChild(apiManager: APIManager) -> MovieListsInteractable?
    func detachMovieLists()
    func openMovieDetail(withId: Int, apiManager: APIManager)
    func detachMovieDetail()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    var didLoadMoreTrigger: PublishSubject<Void> { get }
    
    func updateHeightMovieList(with height: Observable<CGFloat>)
}

protocol HomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {

    weak var router: HomeRouting?
    weak var listener: HomeListener?
    private let apiManager: APIManager
    private var heightOfMovieList = PublishRelay<CGFloat>()
    private let loadMoreTrigger: PublishRelay<Void>
    private let isLoadingRelay: BehaviorRelay<Bool>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: HomePresentable,
        apiManager: APIManager,
        dependency: MovieListsDependency
    ) {
        self.apiManager = apiManager
        self.loadMoreTrigger = dependency.loadMoreTrigger
        self.isLoadingRelay = dependency.isLoadingRelay
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        bindLoadMore()
        self.presenter.updateHeightMovieList(with: heightOfMovieList.asObservable())
        attachFeaturedMovie()
        attachMovieLists()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func attachFeaturedMovie() {
        if let child = router?.attachFeaturedMovieChild(apiManager: apiManager) {
            child.listener = self
        }
    }
    
    private func attachMovieLists() {
        if let child = router?.attachMovieListsChild(apiManager: apiManager) {
            child.listener = self
        }
    }
    
    private func bindLoadMore() {
        self.presenter.didLoadMoreTrigger
            .withLatestFrom(isLoadingRelay)
            .filter { !$0 } // only trigger when child not loading
            .map { _ in () }
            .bind(to: loadMoreTrigger)
            .disposeOnDeactivate(interactor: self)
    }
}

extension HomeInteractor {
    
    func didSelectFeaturedMovie(_ movie: TheMovieTrendingToday.Result) {
        self.router?.openMovieDetail(withId: movie.id, apiManager: apiManager)
    }
    
    func didSelectMovie(_ movie: TheMovieLists.Wrapper) {
        self.router?.openMovieDetail(withId: movie.id, apiManager: apiManager)
    }
    
    func didUpdateHeight(with height: CGFloat) {
        heightOfMovieList.accept(height)
    }
    
    func goBackFromMovieDetail() {
        self.router?.detachMovieDetail()
    }
}
