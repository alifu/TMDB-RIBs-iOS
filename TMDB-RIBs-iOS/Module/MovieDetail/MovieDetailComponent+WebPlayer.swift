//
//  MovieDetailComponent+WebPlayer.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs

/// The dependencies needed from the parent scope of MovieDetail to provide for the WebPlayer scope.
// TODO: Update MovieDetailDependency protocol to inherit this protocol.
protocol MovieDetailDependencyWebPlayer: Dependency {
    // TODO: Declare dependencies needed from the parent scope of MovieDetail to provide dependencies
    // for the WebPlayer scope.
}

extension MovieDetailComponent: WebPlayerDependency {

    // TODO: Implement properties to provide for WebPlayer scope.
}
