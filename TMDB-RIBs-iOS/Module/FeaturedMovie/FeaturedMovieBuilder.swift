//
//  FeaturedMovieBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 13/10/25.
//

import RIBs

protocol FeaturedMovieDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FeaturedMovieComponent: Component<FeaturedMovieDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FeaturedMovieBuildable: Buildable {
    func build(withListener listener: FeaturedMovieListener, apiManager: APIManager) -> FeaturedMovieRouting
}

final class FeaturedMovieBuilder: Builder<FeaturedMovieDependency>, FeaturedMovieBuildable {

    override init(dependency: FeaturedMovieDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FeaturedMovieListener, apiManager: APIManager) -> FeaturedMovieRouting {
        let component = FeaturedMovieComponent(dependency: dependency)
        let viewController = FeaturedMovieViewController()
        let interactor = FeaturedMovieInteractor(
            presenter: viewController,
            apiManager: apiManager
        )
        interactor.listener = listener
        return FeaturedMovieRouter(interactor: interactor, viewController: viewController)
    }
}
