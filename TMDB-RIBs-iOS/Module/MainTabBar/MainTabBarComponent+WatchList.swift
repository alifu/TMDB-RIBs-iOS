//
//  MainTabBarComponent+WatchList.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 30/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of MainTabBar to provide for the WatchList scope.
// TODO: Update MainTabBarDependency protocol to inherit this protocol.
protocol MainTabBarDependencyWatchList: Dependency {
    // TODO: Declare dependencies needed from the parent scope of MainTabBar to provide dependencies
    // for the WatchList scope.
}

extension MainTabBarComponent: WatchListDependency {

    // TODO: Implement properties to provide for WatchList scope.
}
