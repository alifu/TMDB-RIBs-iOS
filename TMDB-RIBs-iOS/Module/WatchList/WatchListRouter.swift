//
//  WatchListRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 30/09/25.
//

import RIBs

protocol WatchListInteractable: Interactable {
    var router: WatchListRouting? { get set }
    var listener: WatchListListener? { get set }
}

protocol WatchListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class WatchListRouter: ViewableRouter<WatchListInteractable, WatchListViewControllable>, WatchListRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: WatchListInteractable, viewController: WatchListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
