//
//  HomeComponent+FeaturedMovie.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 13/10/25.
//

import RIBs

/// The dependencies needed from the parent scope of Home to provide for the FeaturedMovie scope.
// TODO: Update HomeDependency protocol to inherit this protocol.
protocol HomeDependencyFeaturedMovie: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the FeaturedMovie scope.
}

extension HomeComponent: FeaturedMovieDependency {

    // TODO: Implement properties to provide for FeaturedMovie scope.
}
