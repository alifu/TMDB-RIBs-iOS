//
//  MovieListsBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 02/10/25.
//

import RIBs

protocol MovieListsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MovieListsComponent: Component<MovieListsDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MovieListsBuildable: Buildable {
    func build(withListener listener: MovieListsListener, apiManager: APIManager) -> MovieListsRouting
}

final class MovieListsBuilder: Builder<MovieListsDependency>, MovieListsBuildable {

    override init(dependency: MovieListsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MovieListsListener, apiManager: APIManager) -> MovieListsRouting {
        let component = MovieListsComponent(dependency: dependency)
        let viewController = MovieListsViewController()
        let interactor = MovieListsInteractor(
            presenter: viewController,
            apiManager: apiManager
        )
        interactor.listener = listener
        return MovieListsRouter(interactor: interactor, viewController: viewController)
    }
}
