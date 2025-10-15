//
//  WatchListInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol WatchListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func openMovieDetail(withId: Int, apiManager: APIManager)
    func detachMovieDetail()
}

protocol WatchListPresentable: Presentable {
    var listener: WatchListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindMovieItems(_ items: Observable<[TheMovieWatchList.Result]>)
    func loading(_ isLoading: Observable<Bool>)
    func errorViewVisible(_ model: Observable<ErrorViewModel?>)
}

protocol WatchListListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class WatchListInteractor: PresentableInteractor<WatchListPresentable>, WatchListInteractable, WatchListPresentableListener {
    
    weak var router: WatchListRouting?
    weak var listener: WatchListListener?
    private let apiManager: APIManager
    private var movieItemRelay: BehaviorRelay<[TheMovieWatchList.Result]> = .init(value: [])
    private var isLoading = PublishRelay<Bool>()
    private let errorState = BehaviorRelay<ErrorViewModel?>(value: nil)
    
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
        self.presenter.loading(isLoading.asObservable())
        self.presenter.bindMovieItems(movieItemRelay.asObservable())
        self.presenter.errorViewVisible(errorState.asObservable())
        emptyData()
        fetchSearchMovie()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchSearchMovie() {
        isLoading.accept(true)
        errorState.accept(nil)
        let request = TheMovieWatchList.Request(page: 1, language: "en-US")
        apiManager.fetchMovieWatchList(request: request)
            .subscribe(onSuccess: { [weak self] movies in
                guard let self else { return }
                if movies.totalResults == 0 {
                    self.emptyData()
                } else {
                    self.movieItemRelay.accept(movies.results)
                }
                self.isLoading.accept(false)
            }, onFailure: { error in
                print("Error:", error)
                self.isLoading.accept(false)
                self.emptyData()
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func emptyData() {
        errorState.accept(
            ErrorViewModel(
                image: UIImage(named: "empty-box"),
                title: "There is no movie yet!",
                subtitle: "Please save some movie in detail page to watch later."
            )
        )
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
