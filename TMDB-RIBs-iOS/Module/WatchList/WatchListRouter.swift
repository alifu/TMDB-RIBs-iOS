//
//  WatchListRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs

protocol WatchListInteractable: Interactable, MovieDetailListener {
    var router: WatchListRouting? { get set }
    var listener: WatchListListener? { get set }
}

protocol WatchListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func openMovieDetail(viewController: ViewControllable?)
}

final class WatchListRouter: ViewableRouter<WatchListInteractable, WatchListViewControllable>, WatchListRouting {
    
    private let movieDetailBuilder: MovieDetailBuildable
    private var movieDetail: MovieDetailRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: WatchListInteractable,
        viewController: WatchListViewControllable,
        movieDetailBuilder: MovieDetailBuildable
    ) {
        self.movieDetailBuilder = movieDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func openMovieDetail(withId: Int, apiManager: APIManager) {
        let movieDetailRouter = movieDetailBuilder.build(
            withListener: interactor,
            apiManager: apiManager,
            withMovieId: withId
        )
        movieDetail = movieDetailRouter
        attachChild(movieDetailRouter)
        viewController.openMovieDetail(viewController: movieDetail?.viewControllable)
    }
    
    func detachMovieDetail() {
        if let detach = movieDetail {
            detachChild(detach)
            movieDetail = nil
        }
    }
}
