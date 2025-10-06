//
//  MovieListsRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 02/10/25.
//

import RIBs

protocol MovieListsInteractable: Interactable {
    var router: MovieListsRouting? { get set }
    var listener: MovieListsListener? { get set }
}

protocol MovieListsViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MovieListsRouter: ViewableRouter<MovieListsInteractable, MovieListsViewControllable>, MovieListsRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MovieListsInteractable, viewController: MovieListsViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
