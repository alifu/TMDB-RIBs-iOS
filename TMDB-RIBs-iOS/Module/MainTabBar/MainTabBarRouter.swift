//
//  MainTabBarRouter.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 24/09/25.
//

import RIBs
import UIKit

protocol MainTabBarInteractable: Interactable, HomeListener, SearchListener, WatchListListener {
    var router: MainTabBarRouting? { get set }
    var listener: MainTabBarListener? { get set }
}

protocol MainTabBarViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func setViewControllers(_ viewControllers: [UIViewController])
    @available(iOS 26.0, *)
    func setTabs(_ tabs: [UITab])
}

final class MainTabBarRouter: ViewableRouter<MainTabBarInteractable, MainTabBarViewControllable>, MainTabBarRouting {
    
    private let homeBuilder: HomeBuildable
    private let searchBuilder: SearchBuildable
    private let watchListBuilder: WatchListBuildable
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MainTabBarInteractable,
        viewController: MainTabBarViewControllable,
        homeBuilder: HomeBuildable,
        searchBuilder: SearchBuildable,
        watchListBuilder: WatchListBuildable
    ) {
        self.homeBuilder = homeBuilder
        self.searchBuilder = searchBuilder
        self.watchListBuilder = watchListBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let apiManager = APIManager.shared
        
        let homeTabBuilder = homeBuilder.build(
            withListener: interactor,
            apiManager: apiManager
        )
        let searchTabBuilder = searchBuilder.build(withListener: interactor)
        let watchListTabBuilder = watchListBuilder.build(withListener: interactor)
        
        attachChild(homeTabBuilder)
        attachChild(searchTabBuilder)
        attachChild(watchListTabBuilder)
        
        if #available(iOS 26.0, *) {
            let homeNavigation = UINavigationController(rootViewController: homeTabBuilder.viewControllable.uiviewController)
            let homeItem = UITab(
                title: "Home",
                image: UIImage(named: "home")?.withRenderingMode(.alwaysTemplate),
                identifier: "home") { _ in
                    return homeNavigation
                }
            
            let watchListNavigation = UINavigationController(rootViewController: watchListTabBuilder.viewControllable.uiviewController)
            let watchListItem = UITab(
                title: "Watch List",
                image: UIImage(named: "save")?.withRenderingMode(.alwaysTemplate),
                identifier: "watchList") { _ in
                    return watchListNavigation
                }
            
            let searchNavigation = UINavigationController(rootViewController: searchTabBuilder.viewControllable.uiviewController)
            let searchItem = UISearchTab(
                title: "Search",
                image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate),
                identifier: "search") { tab in
                    return searchNavigation
                }
            searchItem.automaticallyActivatesSearch = true
            
            viewController.setTabs([
                homeItem,
                watchListItem,
                searchItem
            ])
        } else {
            let homeNavigation = UINavigationController(rootViewController: homeTabBuilder.viewControllable.uiviewController)
            homeNavigation.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
            
            let watchListNavigation = UINavigationController(rootViewController: watchListTabBuilder.viewControllable.uiviewController)
            watchListNavigation.tabBarItem =  UITabBarItem(title: "Watch List", image: UIImage(named: "save"), tag: 0)
            
            let searchNavigation = UINavigationController(rootViewController: searchTabBuilder.viewControllable.uiviewController)
            searchNavigation.tabBarItem =  UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 0)
            
            viewController.setViewControllers([
                homeNavigation,
                searchNavigation,
                watchListNavigation
            ])
        }
    }
}
