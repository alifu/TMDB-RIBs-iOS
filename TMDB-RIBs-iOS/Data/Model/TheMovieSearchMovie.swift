//
//  TheMovieSearchMovie.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import Foundation
import RxDataSources

struct TheMovieSearchMovie {
    
    struct Request {
        let page: Int
        let language: String
        let includeAdult: Bool
        let query: String
    }
    
    struct Response: Decodable {
        let page: Int
        let totalPages: Int
        let totalResults: Int
        let results: [Result]
        
        enum CodingKeys: String, CodingKey {
            case page
            case totalPages = "total_pages"
            case totalResults = "total_results"
            case results
        }
    }
    
    struct Result: Identifiable, Decodable {
        let adult: Bool
        let backdropPath: String?
        let genreIds: [Int]
        let id: Int
        let originalLanguage: String
        let originalTitle: String
        let overview: String
        let popularity: Double
        let posterPath: String?
        let releaseDate: String?
        let title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int
        
        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIds = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview
            case popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title
            case video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
        
        var releaseYear: String {
            if let releaseDate = releaseDate {
                return String(releaseDate.prefix(4))
            }
            return "N/A"
        }
    }
}

struct SectionOfSearchMovie {
    var header: String
    var items: [TheMovieSearchMovie.Result]
}

extension SectionOfSearchMovie: SectionModelType {
    init(original: SectionOfSearchMovie, items: [TheMovieSearchMovie.Result]) {
        self = original
        self.items = items
    }
}
