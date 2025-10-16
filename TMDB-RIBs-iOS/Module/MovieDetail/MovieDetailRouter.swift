//
//  MovieDetailRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import RIBs
import UIKit

protocol MovieDetailInteractable: Interactable, CarouselMovieListener, MovieDetailInfoListener, WebPlayerListener, MiniTabListener {
    var router: MovieDetailRouting? { get set }
    var listener: MovieDetailListener? { get set }
}

protocol MovieDetailViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachCarousel(viewController: ViewControllable?)
    func attachMovieDetailInfo(viewController: ViewControllable?)
    func attachWebPlayer(viewController: ViewControllable?)
    func attachMiniTabView(viewController: ViewControllable?)
}

final class MovieDetailRouter: ViewableRouter<MovieDetailInteractable, MovieDetailViewControllable>, MovieDetailRouting {
    
    private let movieDetailInfoBuilder: MovieDetailInfoBuildable
    private var movieDetailInfo: MovieDetailInfoRouting?
    private let carouselMovieBuilder: CarouselMovieBuildable
    private var carouselMovie: CarouselMovieRouting?
    private let webPlayerBuilder: WebPlayerBuildable
    private var webPlayer: WebPlayerRouting?
    private var miniTabBuilder: MiniTabBuilder
    private var miniTab: MiniTabRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MovieDetailInteractable,
        viewController: MovieDetailViewControllable,
        movieDetailInfoBuilder: MovieDetailInfoBuildable,
        carouselMovieBuilder: CarouselMovieBuildable,
        webPlayerBuilder: WebPlayerBuildable,
        miniTabBuilder: MiniTabBuilder
    ) {
        self.movieDetailInfoBuilder = movieDetailInfoBuilder
        self.carouselMovieBuilder = carouselMovieBuilder
        self.webPlayerBuilder = webPlayerBuilder
        self.miniTabBuilder = miniTabBuilder
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
    
    func attachCarouselChild() -> CarouselMovieInteractable? {
        guard carouselMovie == nil else { return carouselMovie?.interactable as? CarouselMovieInteractable }
        let childRouter = carouselMovieBuilder.build(withListener: interactor)
        carouselMovie = childRouter
        attachChild(childRouter)
        viewController.attachCarousel(viewController: carouselMovie?.viewControllable)
        return childRouter.interactable as? CarouselMovieInteractable
    }
    
    func detachCarousel() {
        if let detach = carouselMovie {
            detachChild(detach)
            carouselMovie = nil
        }
    }
    
    func attachWebPlayerChild(withURL url: URL) -> (any WebPlayerInteractable)? {
        guard webPlayer == nil else { return webPlayer?.interactable as? WebPlayerInteractable }
        let childRouter = webPlayerBuilder.build(
            withListener: interactor,
            url: url
        )
        webPlayer = childRouter
        attachChild(childRouter)
        viewController.attachWebPlayer(viewController: webPlayer?.viewControllable)
        return childRouter.interactable as? WebPlayerInteractable
    }
    
    func detachWebPlayer() {
        if let detach = webPlayer {
            detachChild(detach)
            webPlayer = nil
        }
    }
    
    func attachMiniTab(_ data: [MiniTab]) -> MiniTabInteractable? {
        guard miniTab == nil else { return miniTab?.interactable as? MiniTabInteractable }
        let childRouter = miniTabBuilder.build(
            withListener: interactor,
            miniTab: data
        )
        miniTab = childRouter
        attachChild(childRouter)
        viewController.attachMiniTabView(viewController: miniTab?.viewControllable)
        return childRouter.interactable as? MiniTabInteractable
    }
    
    func detachMiniTab() {
        if let detach = miniTab {
            detachChild(detach)
            miniTab = nil
        }
    }
}
