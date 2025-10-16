//
//  MiniTabBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs

protocol MiniTabDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MiniTabComponent: Component<MiniTabDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MiniTabBuildable: Buildable {
    func build(withListener listener: MiniTabListener, miniTab: [MiniTab]) -> MiniTabRouting
}

final class MiniTabBuilder: Builder<MiniTabDependency>, MiniTabBuildable {

    override init(dependency: MiniTabDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MiniTabListener, miniTab: [MiniTab]) -> MiniTabRouting {
        let component = MiniTabComponent(dependency: dependency)
        let viewController = MiniTabViewController()
        let interactor = MiniTabInteractor(
            presenter: viewController,
            miniTab: miniTab
        )
        interactor.listener = listener
        return MiniTabRouter(interactor: interactor, viewController: viewController)
    }
}
