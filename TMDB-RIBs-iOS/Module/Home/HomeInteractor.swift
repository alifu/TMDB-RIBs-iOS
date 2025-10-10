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
    func attachPopularMovieChild(apiManager: APIManager) -> PopularMovieInteractable?
    func detachPopularMovie()
    func attachMovieListsChild(apiManager: APIManager) -> MovieListsInteractable?
    func detachMovieLists()
    func openMovieDetail(withId: Int, apiManager: APIManager)
    func detachMovieDetail()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
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

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: HomePresentable,
        apiManager: APIManager
    ) {
        self.apiManager = apiManager
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.updateHeightMovieList(with: heightOfMovieList.asObservable())
        attachPopularMovie()
        attachMovieLists()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func attachPopularMovie() {
        if let child = router?.attachPopularMovieChild(apiManager: apiManager) {
            child.listener = self
        }
    }
    
    private func attachMovieLists() {
        if let child = router?.attachMovieListsChild(apiManager: apiManager) {
            child.listener = self
        }
    }
}

extension HomeInteractor {
    
    func didSelectPopularMovie(_ movie: TheMoviePopular.Result) {
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
