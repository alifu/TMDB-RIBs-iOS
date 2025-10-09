//
//  SearchComponent+MovieDetail.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 09/10/25.
//

import RIBs

/// The dependencies needed from the parent scope of Search to provide for the MovieDetail scope.
// TODO: Update SearchDependency protocol to inherit this protocol.
protocol SearchDependencyMovieDetail: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Search to provide dependencies
    // for the MovieDetail scope.
}

extension SearchComponent: MovieDetailDependency {

    // TODO: Implement properties to provide for MovieDetail scope.
}
