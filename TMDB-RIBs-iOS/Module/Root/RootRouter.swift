//
//  RootRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 24/09/25.
//

import RIBs
import UIKit

protocol RootInteractable: Interactable, MainTabBarListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func attachTabbarView(viewController: ViewControllable?)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    private let tabBarBuilder: MainTabBarBuilder
    var tabBar: MainTabBarRouting?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         tabBarBuilder: MainTabBarBuilder) {
        self.tabBarBuilder = tabBarBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        attachTabBar()
    }
    
    func attachTabBar() {
        let child = tabBarBuilder.build(withListener: interactor)
        attachChild(child)
        tabBar = child
        viewController.attachTabbarView(viewController: child.viewControllable)
        child.attachTabs()
    }
}

extension LaunchRouting {
    func launch(from window: UIWindow) {
        window.rootViewController = viewControllable.uiviewController
        window.makeKeyAndVisible()
    }
}
