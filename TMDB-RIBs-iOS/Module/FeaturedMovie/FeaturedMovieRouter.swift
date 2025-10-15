//
//  FeaturedMovieRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 13/10/25.
//

import RIBs

protocol FeaturedMovieInteractable: Interactable {
    var router: FeaturedMovieRouting? { get set }
    var listener: FeaturedMovieListener? { get set }
}

protocol FeaturedMovieViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FeaturedMovieRouter: ViewableRouter<FeaturedMovieInteractable, FeaturedMovieViewControllable>, FeaturedMovieRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FeaturedMovieInteractable, viewController: FeaturedMovieViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
