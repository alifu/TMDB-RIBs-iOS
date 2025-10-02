//
//  PopularMovieBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 02/10/25.
//

import RIBs

protocol PopularMovieDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PopularMovieComponent: Component<PopularMovieDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PopularMovieBuildable: Buildable {
    func build(withListener listener: PopularMovieListener, apiManager: APIManager) -> PopularMovieRouting
}

final class PopularMovieBuilder: Builder<PopularMovieDependency>, PopularMovieBuildable {

    override init(dependency: PopularMovieDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PopularMovieListener, apiManager: APIManager) -> PopularMovieRouting {
        let component = PopularMovieComponent(dependency: dependency)
        let viewController = PopularMovieViewController()
        let interactor = PopularMovieInteractor(
            presenter: viewController,
            apiManager: apiManager
        )
        interactor.listener = listener
        return PopularMovieRouter(interactor: interactor, viewController: viewController)
    }
}
