//
//  CarouselMovieRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 14/10/25.
//

import RIBs

protocol CarouselMovieInteractable: Interactable {
    var router: CarouselMovieRouting? { get set }
    var listener: CarouselMovieListener? { get set }
}

protocol CarouselMovieViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CarouselMovieRouter: ViewableRouter<CarouselMovieInteractable, CarouselMovieViewControllable>, CarouselMovieRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CarouselMovieInteractable, viewController: CarouselMovieViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
