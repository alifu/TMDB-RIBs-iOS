//
//  PopularMovieInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 02/10/25.
//

import RIBs
import RxCocoa
import RxSwift

protocol PopularMovieRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PopularMoviePresentable: Presentable {
    var listener: PopularMoviePresentableListener? { get set }
    func bindPopularMovie(_ movies: Observable<[TheMoviePopular.Result]>)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PopularMovieListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PopularMovieInteractor: PresentableInteractor<PopularMoviePresentable>, PopularMovieInteractable, PopularMoviePresentableListener {

    weak var router: PopularMovieRouting?
    weak var listener: PopularMovieListener?
    private let apiManager: APIManager
    private var popularMovieRelay = BehaviorRelay<[TheMoviePopular.Result]>(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: PopularMoviePresentable,
        apiManager: APIManager
    ) {
        self.apiManager = apiManager
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        presenter.bindPopularMovie(popularMovieRelay.asObservable())
        fetchPopularMovies()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func fetchPopularMovies() {
        let request = TheMoviePopular.Request(page: 1, language: "en_US")
        apiManager.fetchPopularMovie(request: request).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                popularMovieRelay.accept(response.results)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
}
