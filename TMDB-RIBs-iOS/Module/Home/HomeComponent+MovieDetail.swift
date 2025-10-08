//
//  HomeComponent+MovieDetail.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import RIBs

/// The dependencies needed from the parent scope of Home to provide for the MovieDetail scope.
// TODO: Update HomeDependency protocol to inherit this protocol.
protocol HomeDependencyMovieDetail: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Home to provide dependencies
    // for the MovieDetail scope.
}

extension HomeComponent: MovieDetailDependency {

    // TODO: Implement properties to provide for MovieDetail scope.
}
