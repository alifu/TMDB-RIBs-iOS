//
//  WatchListBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs

protocol WatchListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class WatchListComponent: Component<WatchListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol WatchListBuildable: Buildable {
    func build(withListener listener: WatchListListener, apiManager: APIManager) -> WatchListRouting
}

final class WatchListBuilder: Builder<WatchListDependency>, WatchListBuildable {

    override init(dependency: WatchListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: WatchListListener, apiManager: APIManager) -> WatchListRouting {
        let component = WatchListComponent(dependency: dependency)
        let viewController = WatchListViewController()
        let interactor = WatchListInteractor(
            presenter: viewController,
            apiManager: apiManager
        )
        let movieDetailBuilder = MovieDetailBuilder(dependency: component)
        interactor.listener = listener
        return WatchListRouter(
            interactor: interactor,
            viewController: viewController,
            movieDetailBuilder: movieDetailBuilder
        )
    }
}
