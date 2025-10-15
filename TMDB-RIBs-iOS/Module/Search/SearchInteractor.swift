//
//  SearchInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol SearchRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func openMovieDetail(withId: Int, apiManager: APIManager)
    func detachMovieDetail()
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindMovieItems(_ items: Observable<[TheMovieSearch.Result]>)
    func loading(_ isLoading: Observable<Bool>)
    func errorViewVisible(_ model: Observable<ErrorViewModel?>)
}

protocol SearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    
    weak var router: SearchRouting?
    weak var listener: SearchListener?
    private let apiManager: APIManager
    private var movieItemRelay: BehaviorRelay<[TheMovieSearch.Result]> = .init(value: [])
    private var isLoading = PublishRelay<Bool>()
    private let errorState = BehaviorRelay<ErrorViewModel?>(value: nil)
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: SearchPresentable,
        apiManager: APIManager
    ) {
        self.apiManager = apiManager
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.errorViewVisible(errorState.asObservable())
        self.presenter.loading(isLoading.asObservable())
        self.presenter.bindMovieItems(movieItemRelay.asObservable())
        emptyData()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchSearchMovie(with query: String) {
        isLoading.accept(true)
        errorState.accept(nil)
        let request = TheMovieSearch.Request(page: 1, language: "en-US", includeAdult: true, query: query)
        apiManager.fetchSearchMovie(request: request)
            .subscribe(onSuccess: { [weak self] movies in
                guard let self else { return }
                self.isLoading.accept(false)
                if movies.totalResults == 0 {
                    self.errorState.accept(
                        ErrorViewModel(
                            image: UIImage(named: "no-result"),
                            title: "We Are Sorry, We Can Not Find The Movie :(",
                            subtitle: "Find your movie by Type title, categories, years, etc "
                        )
                    )
                } else {
                    self.errorState.accept(nil)
                    self.movieItemRelay.accept(movies.results)
                }
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
                subtitle: "Find your movie by Type title in search box."
            )
        )
    }
    
    func didSearch(with query: String) {
        fetchSearchMovie(with: query)
    }
}

extension SearchInteractor {
    
    func goBackFromMovieDetail() {
        self.router?.detachMovieDetail()
    }
    
    func didSelectMovie(_ movie: TheMovieSearch.Result) {
        self.router?.openMovieDetail(withId: movie.id, apiManager: apiManager)
    }
}
