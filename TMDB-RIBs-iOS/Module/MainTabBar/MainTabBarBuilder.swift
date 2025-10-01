//
//  MainTabBarBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 24/09/25.
//

import RIBs

protocol MainTabBarDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainTabBarComponent: Component<MainTabBarDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MainTabBarBuildable: Buildable {
    func build(withListener listener: MainTabBarListener) -> MainTabBarRouting
}

final class MainTabBarBuilder: Builder<MainTabBarDependency>, MainTabBarBuildable {

    override init(dependency: MainTabBarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainTabBarListener) -> MainTabBarRouting {
        let component = MainTabBarComponent(dependency: dependency)
        let viewController = MainTabBarViewController()
        let interactor = MainTabBarInteractor(presenter: viewController)
        let homeBuilder = HomeBuilder(dependency: component)
        let searchBuilder = SearchBuilder(dependency: component)
        let watchListBuilder = WatchListBuilder(dependency: component)
        interactor.listener = listener
        
        return MainTabBarRouter(
            interactor: interactor,
            viewController: viewController,
            homeBuilder: homeBuilder,
            searchBuilder: searchBuilder,
            watchListBuilder: watchListBuilder
        )
    }
}
