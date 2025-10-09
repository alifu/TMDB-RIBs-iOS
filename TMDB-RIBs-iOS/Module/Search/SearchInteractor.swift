//
//  SearchInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa
import RxSwift

protocol SearchRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func openMovieDetail(withId: Int, apiManager: APIManager)
    func detachMovieDetail()
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindMovieItems(_ items: Observable<[TheMovieSearchMovie.Result]>)
}

protocol SearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    
    weak var router: SearchRouting?
    weak var listener: SearchListener?
    private let apiManager: APIManager
    private var movieItemRelay: BehaviorRelay<[TheMovieSearchMovie.Result]> = .init(value: [])
    
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
        self.presenter.bindMovieItems(movieItemRelay.asObservable())
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchSearchMovie(with query: String) {
        let request = TheMovieSearchMovie.Request(page: 1, language: "en-US", includeAdult: true, query: query)
        apiManager.fetchSearchMovie(request: request)
            .subscribe(onSuccess: { [weak self] movies in
                guard let self else { return }
                self.movieItemRelay.accept(movies.results)
            }, onFailure: { error in
                print("Error:", error)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    func didSearch(with query: String) {
        fetchSearchMovie(with: query)
    }
}

extension SearchInteractor {
    
    func goBackFromMovieDetail() {
        self.router?.detachMovieDetail()
    }
    
    func didSelectMovie(_ movie: TheMovieSearchMovie.Result) {
        self.router?.openMovieDetail(withId: movie.id, apiManager: apiManager)
    }
}
