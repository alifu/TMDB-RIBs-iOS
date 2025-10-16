//
//  MovieListsBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 02/10/25.
//

import RIBs
import RxCocoa
import Foundation

protocol MovieListsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var loadMoreTrigger: PublishRelay<Void> { get }
    var isLoadingRelay: BehaviorRelay<Bool> { get }
    var selectedMiniTabRelay: PublishRelay<(IndexPath, MiniTab)> { get }
}

final class MovieListsComponent: Component<MovieListsDependency>, MovieListsDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    internal var loadMoreTrigger: RxRelay.PublishRelay<Void> {
        dependency.loadMoreTrigger
    }
    internal var isLoadingRelay: RxRelay.BehaviorRelay<Bool> {
        dependency.isLoadingRelay
    }
    var selectedMiniTabRelay: PublishRelay<(IndexPath, MiniTab)> {
        dependency.selectedMiniTabRelay
    }
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
            apiManager: apiManager,
            dependecy: component
        )
        interactor.listener = listener
        return MovieListsRouter(interactor: interactor, viewController: viewController)
    }
}
