//
//  MovieDetailInfoBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 08/10/25.
//

import Foundation
import RIBs
import RxCocoa

protocol MovieDetailInfoDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var aboutMovieRelay: BehaviorRelay<String?> { get }
    var selectedMiniTabRelay: PublishRelay<(IndexPath, MiniTab)> { get }
}

final class MovieDetailInfoComponent: Component<MovieDetailInfoDependency>, MovieDetailInfoDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    internal var aboutMovieRelay: BehaviorRelay<String?> {
        dependency.aboutMovieRelay
    }
    internal var selectedMiniTabRelay: PublishRelay<(IndexPath, MiniTab)> {
        dependency.selectedMiniTabRelay
    }
}

// MARK: - Builder

protocol MovieDetailInfoBuildable: Buildable {
    func build(withListener listener: MovieDetailInfoListener, apiManager: APIManager, withMovieId: Int) -> MovieDetailInfoRouting
}

final class MovieDetailInfoBuilder: Builder<MovieDetailInfoDependency>, MovieDetailInfoBuildable {

    override init(dependency: MovieDetailInfoDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MovieDetailInfoListener, apiManager: APIManager, withMovieId: Int) -> MovieDetailInfoRouting {
        let component = MovieDetailInfoComponent(dependency: dependency)
        let viewController = MovieDetailInfoViewController()
        let interactor = MovieDetailInfoInteractor(
            presenter: viewController,
            dependency: component,
            apiManager: apiManager,
            withMovieId: withMovieId
        )
        interactor.listener = listener
        return MovieDetailInfoRouter(interactor: interactor, viewController: viewController)
    }
}
