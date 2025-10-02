//
//  HomeComponent+PopularMovie.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 02/10/25.
//

import RIBs

/// The dependencies needed from the parent scope of Home to provide for the PopularMovie scope.
// TODO: Update HomeDependency protocol to inherit this protocol.
protocol HomeDependencyPopularMovie: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the PopularMovie scope.
}

extension HomeComponent: PopularMovieDependency {

    // TODO: Implement properties to provide for PopularMovie scope.
}
