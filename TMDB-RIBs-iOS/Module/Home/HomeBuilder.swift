//
//  HomeBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa

protocol HomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class HomeComponent: Component<HomeDependency>, MovieListsDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    let loadMoreTrigger = PublishRelay<Void>()
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener, apiManager: APIManager) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener, apiManager: APIManager) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)
        let viewController = HomeViewController()
        let interactor = HomeInteractor(
            presenter: viewController,
            apiManager: apiManager,
            dependency: component
        )
        let featuredMovieBuilder = FeaturedMovieBuilder(dependency: component)
        let movieListsBuilder = MovieListsBuilder(dependency: component)
        let movieDetailBuilder = MovieDetailBuilder(dependency: component)
        interactor.listener = listener
        return HomeRouter(
            interactor: interactor,
            viewController: viewController,
            featuredMovieBuilder: featuredMovieBuilder,
            movieListsBuilder: movieListsBuilder,
            movieDetailBuilder: movieDetailBuilder
        )
    }
}
