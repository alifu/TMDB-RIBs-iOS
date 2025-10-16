//
//  HomeComponent+MiniTab.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs

/// The dependencies needed from the parent scope of Home to provide for the MiniTab scope.
// TODO: Update HomeDependency protocol to inherit this protocol.
protocol HomeDependencyMiniTab: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the MiniTab scope.
}

extension HomeComponent: MiniTabDependency {

    // TODO: Implement properties to provide for MiniTab scope.
}
