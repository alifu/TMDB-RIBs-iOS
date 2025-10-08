//
//  HomeRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs

protocol HomeInteractable: Interactable, PopularMovieListener, MovieListsListener, MovieDetailListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachPopularMovieView(viewController: ViewControllable?)
    func attachMovieListsView(viewController: ViewControllable?)
    func openMovieDetail(viewController: ViewControllable?)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    
    private let popularMovieBuilder: PopularMovieBuildable
    private var popularMovie: PopularMovieRouting?
    private let movieListsBuilder: MovieListsBuildable
    private var movieLists: MovieListsRouting?
    private let movieDetailBuilder: MovieDetailBuildable
    private var movieDetail: MovieDetailRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: HomeInteractable,
        viewController: HomeViewControllable,
        popularMovieBuilder: PopularMovieBuildable,
        movieListsBuilder: MovieListsBuildable,
        movieDetailBuilder: MovieDetailBuildable
    ) {
        self.popularMovieBuilder = popularMovieBuilder
        self.movieListsBuilder = movieListsBuilder
        self.movieDetailBuilder = movieDetailBuilder
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
}
