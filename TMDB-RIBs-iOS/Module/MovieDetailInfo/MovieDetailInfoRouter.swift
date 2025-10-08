//
//  MovieDetailInfoRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 08/10/25.
//

import RIBs

protocol MovieDetailInfoInteractable: Interactable {
    var router: MovieDetailInfoRouting? { get set }
    var listener: MovieDetailInfoListener? { get set }
}

protocol MovieDetailInfoViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MovieDetailInfoRouter: ViewableRouter<MovieDetailInfoInteractable, MovieDetailInfoViewControllable>, MovieDetailInfoRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MovieDetailInfoInteractable, viewController: MovieDetailInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
