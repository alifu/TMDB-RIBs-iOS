//
//  RootRouter+Deeplink.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 16/10/25.
//

import RIBs

extension RootRouter: DeeplinkHandler {
    
    @discardableResult
    func handleDeeplink(_ deeplink: Deeplink) -> Bool {
        switch deeplink {
        case .search(let query):
            attachTabBarIfNeeded()
            tabBar?.routeToSearch(query: query)
            return true
            
        default:
            return false
        }
    }
    
    private func attachTabBarIfNeeded() {
        if tabBar == nil {
            attachTabBar()
        }
    }
}
