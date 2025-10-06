//
//  TheMovieUpComing.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 06/10/25.
//

import Foundation
import RxDataSources

struct TheMovieUpComing {
    
    struct Request {
        let page: Int
        let language: String
    }
    
    struct Response: Decodable {
        let page: Int
        let totalPages: Int
        let totalResults: Int
        let results: [Result]
        let dates: Dates
        
        enum CodingKeys: String, CodingKey {
            case page
            case totalPages = "total_pages"
            case totalResults = "total_results"
            case results
            case dates
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
        
        func toWrapper() -> TheMovieLists.Wrapper {
            return TheMovieLists.Wrapper(id: self.id, posterPath: self.posterPath)
        }
    }
    
    struct Dates: Decodable {
        let maximum: String
        let minimum: String
    }
}

struct SectionOfUpComingMovie {
    var header: String
    var items: [TheMovieUpComing.Result]
}

extension SectionOfUpComingMovie: SectionModelType {
    init(original: SectionOfUpComingMovie, items: [TheMovieUpComing.Result]) {
        self = original
        self.items = items
    }
}

extension Array where Element == TheMovieUpComing.Result {
    func toWrappers() -> [TheMovieLists.Wrapper] {
        return self.map { $0.toWrapper() }
    }
}
