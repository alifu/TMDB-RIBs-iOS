//
//  PopularMovieRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 02/10/25.
//

import RIBs

protocol PopularMovieInteractable: Interactable {
    var router: PopularMovieRouting? { get set }
    var listener: PopularMovieListener? { get set }
}

protocol PopularMovieViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PopularMovieRouter: ViewableRouter<PopularMovieInteractable, PopularMovieViewControllable>, PopularMovieRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PopularMovieInteractable, viewController: PopularMovieViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
