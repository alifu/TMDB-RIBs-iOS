//
//  WebPlayerRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs

protocol WebPlayerInteractable: Interactable {
    var router: WebPlayerRouting? { get set }
    var listener: WebPlayerListener? { get set }
}

protocol WebPlayerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class WebPlayerRouter: ViewableRouter<WebPlayerInteractable, WebPlayerViewControllable>, WebPlayerRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: WebPlayerInteractable, viewController: WebPlayerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
