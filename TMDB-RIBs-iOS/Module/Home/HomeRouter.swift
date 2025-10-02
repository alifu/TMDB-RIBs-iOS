//
//  HomeRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs

protocol HomeInteractable: Interactable, PopularMovieListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachPopularMovieView(viewController: ViewControllable?)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    private let popularMovieBuilder: PopularMovieBuildable
    private var popularMovie: PopularMovieRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        popularMovieBuilder: PopularMovieBuildable
    ) {
        self.popularMovieBuilder = popularMovieBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachPopularMovieChild(apiManager: APIManager) -> (any PopularMovieInteractable)? {
        guard popularMovie == nil else { return popularMovie?.interactable as? PopularMovieInteractable }
        let childRouter = popularMovieBuilder.build(withListener: interactor, apiManager: apiManager)
        popularMovie = childRouter
        attachChild(childRouter)
        viewController.attachPopularMovieView(viewController: popularMovie?.viewControllable)
        return childRouter.interactable as? PopularMovieInteractable
    }
    
    func detachPopularMovie() {
        if let detach = popularMovie {
            detachChild(detach)
            popularMovie = nil
        }
    }
}
