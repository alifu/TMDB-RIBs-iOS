//
//  TheMovieDetailInfo.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 08/10/25.
//

import Foundation
import RxDataSources

enum MovieDetailInfoType: String {
    case aboutMovie = "About Movie"
    case reviews = "Reviews"
    case cast = "Cast"
}

struct TheMovieDetailInfo {
    
    struct Tab: Identifiable {
        let id: Int
        let title: String
        let type: MovieDetailInfoType
        var isSelected: Bool = false
        
        mutating func toggle() {
            self.isSelected.toggle()
        }
    }
    
    struct Wrapper {
        let id: Int
        let posterPath: String?
    }
}

let theMovieDetailInfo: [TheMovieDetailInfo.Tab] = [
    TheMovieDetailInfo.Tab(id: 1, title: MovieDetailInfoType.aboutMovie.rawValue, type: .aboutMovie, isSelected: true),
    TheMovieDetailInfo.Tab(id: 2, title: MovieDetailInfoType.reviews.rawValue, type: .reviews),
    TheMovieDetailInfo.Tab(id: 3, title: MovieDetailInfoType.cast.rawValue, type: .cast)
]

extension Array where Element == TheMovieDetailInfo.Tab {
    mutating func select(id: Int) {
        for i in indices {
            self[i].isSelected = (self[i].id == id)
        }
    }
}

struct SectionOfMovieDetailInfo {
    var header: String
    var items: [TheMovieDetailInfo.Tab]
}

extension SectionOfMovieDetailInfo: SectionModelType {
    init(original: SectionOfMovieDetailInfo, items: [TheMovieDetailInfo.Tab]) {
        self = original
        self.items = items
    }
}
