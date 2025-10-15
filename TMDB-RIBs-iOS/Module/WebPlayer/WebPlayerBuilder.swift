//
//  WebPlayerBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs
import UIKit

protocol WebPlayerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class WebPlayerComponent: Component<WebPlayerDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol WebPlayerBuildable: Buildable {
    func build(withListener listener: WebPlayerListener, url: URL) -> WebPlayerRouting
}

final class WebPlayerBuilder: Builder<WebPlayerDependency>, WebPlayerBuildable {

    override init(dependency: WebPlayerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: WebPlayerListener, url: URL) -> WebPlayerRouting {
        let component = WebPlayerComponent(dependency: dependency)
        let viewController = WebPlayerViewController()
        let interactor = WebPlayerInteractor(
            presenter: viewController,
            url: url
        )
        interactor.listener = listener
        return WebPlayerRouter(interactor: interactor, viewController: viewController)
    }
}
