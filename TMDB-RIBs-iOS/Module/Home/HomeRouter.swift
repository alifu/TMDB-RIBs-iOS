//
//  HomeRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs

protocol HomeInteractable: Interactable, FeaturedMovieListener, MovieListsListener, MovieDetailListener, MiniTabListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachFeaturedMovieView(viewController: ViewControllable?)
    func attachMiniTabView(viewController: ViewControllable?)
    func attachMovieListsView(viewController: ViewControllable?)
    func openMovieDetail(viewController: ViewControllable?)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    private let featuredMovieBuilder: FeaturedMovieBuilder
    private var featuredMovie: FeaturedMovieRouting?
    private let movieListsBuilder: MovieListsBuildable
    private var movieLists: MovieListsRouting?
    private let movieDetailBuilder: MovieDetailBuildable
    private var movieDetail: MovieDetailRouting?
    private var miniTabBuilder: MiniTabBuilder
    private var miniTab: MiniTabRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        featuredMovieBuilder: FeaturedMovieBuilder,
        movieListsBuilder: MovieListsBuildable,
        movieDetailBuilder: MovieDetailBuildable,
        miniTabBuilder: MiniTabBuilder
    ) {
        self.featuredMovieBuilder = featuredMovieBuilder
        self.movieListsBuilder = movieListsBuilder
        self.movieDetailBuilder = movieDetailBuilder
        self.miniTabBuilder = miniTabBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachFeaturedMovieChild(apiManager: APIManager) -> (any FeaturedMovieInteractable)? {
        guard featuredMovie == nil else { return featuredMovie?.interactable as? FeaturedMovieInteractable }
        let childRouter = featuredMovieBuilder.build(withListener: interactor, apiManager: apiManager)
        featuredMovie = childRouter
        attachChild(childRouter)
        viewController.attachFeaturedMovieView(viewController: featuredMovie?.viewControllable)
        return childRouter.interactable as? FeaturedMovieInteractable
    }
    
    func detachFeaturedMovie() {
        if let detach = featuredMovie {
            detachChild(detach)
            featuredMovie = nil
        }
    }
    
    func attachMovieListsChild(apiManager: APIManager) -> (any MovieListsInteractable)? {
        guard movieLists == nil else { return movieLists?.interactable as? MovieListsInteractable }
        let childRouter = movieListsBuilder.build(withListener: interactor, apiManager: apiManager)
        movieLists = childRouter
        attachChild(childRouter)
        viewController.attachMovieListsView(viewController: movieLists?.viewControllable)
        return childRouter.interactable as? MovieListsInteractable
    }
    
    func detachMovieLists() {
        if let detach = movieLists {
            detachChild(detach)
            movieLists = nil
        }
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
