//
//  FeaturedMovieInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 13/10/25.
//

import RIBs
import RxCocoa
import RxSwift

protocol FeaturedMovieRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FeaturedMoviePresentable: Presentable {
    var listener: FeaturedMoviePresentableListener? { get set }
    func bindFeaturedMovie(_ movies: Observable<[TheMovieTrendingToday.Result]>)
    func loading(_ isLoading: Observable<Bool>)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FeaturedMovieListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didSelectFeaturedMovie(_ movie: TheMovieTrendingToday.Result)
}

final class FeaturedMovieInteractor: PresentableInteractor<FeaturedMoviePresentable>, FeaturedMovieInteractable, FeaturedMoviePresentableListener {

    weak var router: FeaturedMovieRouting?
    weak var listener: FeaturedMovieListener?
    private let apiManager: APIManager
    private var featuredMovieRelay = BehaviorRelay<[TheMovieTrendingToday.Result]>(value: [])
    private var isLoading = PublishRelay<Bool>()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: FeaturedMoviePresentable,
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
        presenter.bindFeaturedMovie(featuredMovieRelay.asObservable())
        fetchFeaturedMovies()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchFeaturedMovies() {
        isLoading.accept(true)
        let request = TheMovieTrendingToday.Request(page: 1, language: "en_US")
        apiManager.fetchTrendingTodayMovie(request: request).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                self.featuredMovieRelay.accept(response.results)
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

extension FeaturedMovieInteractor {
    
    func didSelectedMovie(_ movie: TheMovieTrendingToday.Result) {
        self.listener?.didSelectFeaturedMovie(movie)
    }
}
