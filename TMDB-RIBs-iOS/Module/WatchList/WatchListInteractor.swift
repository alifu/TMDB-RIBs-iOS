//
//  WatchListInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa
import RxSwift

protocol WatchListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func openMovieDetail(withId: Int, apiManager: APIManager)
    func detachMovieDetail()
}

protocol WatchListPresentable: Presentable {
    var listener: WatchListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindMovieItems(_ items: Observable<[TheMovieWatchList.Result]>)
}

protocol WatchListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class WatchListInteractor: PresentableInteractor<WatchListPresentable>, WatchListInteractable, WatchListPresentableListener {

    weak var router: WatchListRouting?
    weak var listener: WatchListListener?
    private let apiManager: APIManager
    private var movieItemRelay: BehaviorRelay<[TheMovieWatchList.Result]> = .init(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: WatchListPresentable,
        apiManager: APIManager
    ) {
        self.apiManager = apiManager
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.bindMovieItems(movieItemRelay.asObservable())
        fetchSearchMovie()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchSearchMovie() {
        let request = TheMovieWatchList.Request(page: 1, language: "en-US")
        apiManager.fetchMovieWatchList(request: request)
            .subscribe(onSuccess: { [weak self] movies in
                guard let self else { return }
                self.movieItemRelay.accept(movies.results)
            }, onFailure: { error in
                print("Error:", error)
            })
            .disposeOnDeactivate(interactor: self)
    }
}

extension WatchListInteractor {
    
    func goBackFromMovieDetail() {
        self.router?.detachMovieDetail()
    }
    
    func didSelectMovie(_ movie: TheMovieWatchList.Result) {
        self.router?.openMovieDetail(withId: movie.id, apiManager: apiManager)
    }
}
