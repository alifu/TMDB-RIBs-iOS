//
//  TheMovieLists.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 02/10/25.
//

import Foundation
import RxDataSources

enum MovieListsType: String {
    case topRated = "Top Rated"
    case popular = "Popular"
    case upcoming = "Upcoming"
    case nowPlaying = "Now Playing"
}

struct TheMovieLists {
    
    struct Tab: Identifiable {
        let id: Int
        let title: String
        let type: MovieListsType
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

let theMovieLists: [TheMovieLists.Tab] = [
    TheMovieLists.Tab(id: 1, title: MovieListsType.nowPlaying.rawValue, type: .nowPlaying, isSelected: true),
    TheMovieLists.Tab(id: 2, title: MovieListsType.upcoming.rawValue, type: .upcoming),
    TheMovieLists.Tab(id: 3, title: MovieListsType.topRated.rawValue, type: .topRated),
    TheMovieLists.Tab(id: 4, title: MovieListsType.popular.rawValue, type: .popular)
]

extension Array where Element == TheMovieLists.Tab {
    mutating func select(id: Int) {
        for i in indices {
            self[i].isSelected = (self[i].id == id)
        }
    }
}

struct SectionOfMovieLists {
    var header: String
    var items: [TheMovieLists.Tab]
}

extension SectionOfMovieLists: SectionModelType {
    init(original: SectionOfMovieLists, items: [TheMovieLists.Tab]) {
        self = original
        self.items = items
    }
}

struct SectionOfMovies {
    var header: String
    var items: [TheMovieLists.Wrapper]
}

extension SectionOfMovies: SectionModelType {
    init(original: SectionOfMovies, items: [TheMovieLists.Wrapper]) {
        self = original
        self.items = items
    }
}
