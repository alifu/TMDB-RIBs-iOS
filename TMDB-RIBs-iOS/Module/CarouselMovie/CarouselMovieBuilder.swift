//
//  CarouselMovieBuilder.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 14/10/25.
//

import RIBs
import RxCocoa
import RxSwift

protocol CarouselMovieDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var carouselMovieItems: BehaviorRelay<[TheMovieCaraousel]> { get }
}

final class CarouselMovieComponent: Component<CarouselMovieDependency>, CarouselMovieDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    internal var carouselMovieItems: BehaviorRelay<[TheMovieCaraousel]> {
        dependency.carouselMovieItems
    }
}

// MARK: - Builder

protocol CarouselMovieBuildable: Buildable {
    func build(withListener listener: CarouselMovieListener) -> CarouselMovieRouting
}

final class CarouselMovieBuilder: Builder<CarouselMovieDependency>, CarouselMovieBuildable {

    override init(dependency: CarouselMovieDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CarouselMovieListener) -> CarouselMovieRouting {
        let component = CarouselMovieComponent(dependency: dependency)
        let viewController = CarouselMovieViewController()
        let interactor = CarouselMovieInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return CarouselMovieRouter(interactor: interactor, viewController: viewController)
    }
}
