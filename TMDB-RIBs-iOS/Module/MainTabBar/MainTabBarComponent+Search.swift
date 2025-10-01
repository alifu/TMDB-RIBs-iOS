//
//  MainTabBarComponent+Search.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of MainTabBar to provide for the Search scope.
// TODO: Update MainTabBarDependency protocol to inherit this protocol.
protocol MainTabBarDependencySearch: Dependency {
    // TODO: Declare dependencies needed from the parent scope of MainTabBar to provide dependencies
    // for the Search scope.
}

extension MainTabBarComponent: SearchDependency {

    // TODO: Implement properties to provide for Search scope.
}
