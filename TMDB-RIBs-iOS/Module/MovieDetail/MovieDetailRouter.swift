//
//  MovieDetailRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import RIBs

protocol MovieDetailInteractable: Interactable, MovieDetailInfoListener {
    var router: MovieDetailRouting? { get set }
    var listener: MovieDetailListener? { get set }
}

protocol MovieDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachMovieDetailInfo(viewController: ViewControllable?)
}

final class MovieDetailRouter: ViewableRouter<MovieDetailInteractable, MovieDetailViewControllable>, MovieDetailRouting {
    
    private let movieDetailInfoBuilder: MovieDetailInfoBuildable
    private var movieDetailInfo: MovieDetailInfoRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MovieDetailInteractable,
        viewController: MovieDetailViewControllable,
        movieDetailInfoBuilder: MovieDetailInfoBuildable
    ) {
        self.movieDetailInfoBuilder = movieDetailInfoBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachMovieDetailInfoChild(apiManager: APIManager, withId: Int) -> MovieDetailInfoInteractable? {
        guard movieDetailInfo == nil else { return movieDetailInfo?.interactable as? MovieDetailInfoInteractable }
        let childRouter = movieDetailInfoBuilder.build(
            withListener: interactor,
            apiManager: apiManager,
            withMovieId: withId
        )
        movieDetailInfo = childRouter
        attachChild(childRouter)
        viewController.attachMovieDetailInfo(viewController: movieDetailInfo?.viewControllable)
        return childRouter.interactable as? MovieDetailInfoInteractable
    }
    
    func detachMovieDetailInfo() {
        if let detach = movieDetailInfo {
            detachChild(detach)
            movieDetailInfo = nil
        }
    }
}
