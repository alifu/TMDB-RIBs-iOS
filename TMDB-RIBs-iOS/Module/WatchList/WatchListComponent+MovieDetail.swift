//
//  WatchListComponent+MovieDetail.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 09/10/25.
//

import RIBs

/// The dependencies needed from the parent scope of WatchList to provide for the MovieDetail scope.
// TODO: Update WatchListDependency protocol to inherit this protocol.
protocol WatchListDependencyMovieDetail: Dependency {
    // TODO: Declare dependencies needed from the parent scope of WatchList to provide dependencies
    // for the MovieDetail scope.
}

extension WatchListComponent: MovieDetailDependency {

    // TODO: Implement properties to provide for MovieDetail scope.
}
