//
//  RootComponent+MainTabBar.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 30/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the MainTabBar scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyMainTabBar: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the MainTabBar scope.
}

extension RootComponent: MainTabBarDependency {

    // TODO: Implement properties to provide for MainTabBar scope.
}
