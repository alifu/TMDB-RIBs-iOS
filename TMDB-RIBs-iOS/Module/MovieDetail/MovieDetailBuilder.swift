//
//  MovieDetailBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import RIBs
import RxCocoa

protocol MovieDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MovieDetailComponent: Component<MovieDetailDependency>, MovieDetailInfoDependency, CarouselMovieDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var aboutMovieRelay: BehaviorRelay<String?> = .init(value: nil)
    var carouselMovieItems: BehaviorRelay<[TheMovieCaraousel]> = .init(value: [])
}

// MARK: - Builder

protocol MovieDetailBuildable: Buildable {
    func build(withListener listener: MovieDetailListener, apiManager: APIManager, withMovieId: Int) -> MovieDetailRouting
}

final class MovieDetailBuilder: Builder<MovieDetailDependency>, MovieDetailBuildable {

    override init(dependency: MovieDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MovieDetailListener, apiManager: APIManager, withMovieId: Int) -> MovieDetailRouting {
        let component = MovieDetailComponent(dependency: dependency)
        let viewController = MovieDetailViewController()
        let interactor = MovieDetailInteractor(
            presenter: viewController,
            dependencyInfo: component,
            dependencyCarousel: component,
            apiManager: apiManager,
            withMovieId: withMovieId
        )
        let movieDetailInfoBuilder = MovieDetailInfoBuilder(dependency: component)
        let carouselBuilder = CarouselMovieBuilder(dependency: component)
        let webPlayerBuilder = WebPlayerBuilder(dependency: component)
        interactor.listener = listener
        return MovieDetailRouter(
            interactor: interactor,
            viewController: viewController,
            movieDetailInfoBuilder: movieDetailInfoBuilder,
            carouselMovieBuilder: carouselBuilder,
            webPlayerBuilder: webPlayerBuilder
        )
    }
}
