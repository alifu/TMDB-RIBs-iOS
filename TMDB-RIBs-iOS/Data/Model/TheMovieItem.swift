//
//  TheMovieItem.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import Foundation
import RxDataSources

struct MovieItem {
    let id: Int
    let title: String
    let posterURL: String?
    let rating: Double
    let releaseYear: String
    let runtime: Int
    let genres: [String]
}

struct MovieDetailResponse: Decodable {
    let runtime: Int
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct SectionOfMovieItem {
    var header: String
    var items: [MovieItem]
}

extension SectionOfMovieItem: SectionModelType {
    init(original: SectionOfMovieItem, items: [MovieItem]) {
        self = original
        self.items = items
    }
}
