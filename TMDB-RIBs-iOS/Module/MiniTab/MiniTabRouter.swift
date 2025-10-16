//
//  MiniTabRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs

protocol MiniTabInteractable: Interactable {
    var router: MiniTabRouting? { get set }
    var listener: MiniTabListener? { get set }
}

protocol MiniTabViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MiniTabRouter: ViewableRouter<MiniTabInteractable, MiniTabViewControllable>, MiniTabRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MiniTabInteractable, viewController: MiniTabViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
