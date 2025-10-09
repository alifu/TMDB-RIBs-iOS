//
//  PopularMovieInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 02/10/25.
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
    func loading(_ isLoading: Observable<Bool>)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PopularMovieListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didSelectPopularMovie(_ movie: TheMoviePopular.Result)
}

final class PopularMovieInteractor: PresentableInteractor<PopularMoviePresentable>, PopularMovieInteractable, PopularMoviePresentableListener {

    weak var router: PopularMovieRouting?
    weak var listener: PopularMovieListener?
    private let apiManager: APIManager
    private var popularMovieRelay = BehaviorRelay<[TheMoviePopular.Result]>(value: [])
    private var isLoading = PublishRelay<Bool>()

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
        presenter.loading(isLoading.asObservable())
        presenter.bindPopularMovie(popularMovieRelay.asObservable())
        fetchPopularMovies()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchPopularMovies() {
        isLoading.accept(true)
        let request = TheMoviePopular.Request(page: 1, language: "en_US")
        apiManager.fetchPopularMovie(request: request).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                self.popularMovieRelay.accept(response.results)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
}

extension PopularMovieInteractor {
    
    func didSelectedMovie(_ movie: TheMoviePopular.Result) {
        self.listener?.didSelectPopularMovie(movie)
    }
}
