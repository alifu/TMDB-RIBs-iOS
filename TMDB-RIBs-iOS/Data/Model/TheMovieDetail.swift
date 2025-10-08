//
//  TheMovieDetail.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import Foundation

struct TheMovieDetail {
    
    struct Request {
        let id: Int
    }

    struct Response: Codable {
        let adult: Bool
        let backdropPath: String?
        let belongsToCollection: BelongsToCollection?
        let budget: Int
        let genres: [Genre]
        let homepage: String?
        let id: Int
        let imdbID: String?
        let originCountry: [String]
        let originalLanguage: String
        let originalTitle: String
        let overview: String?
        let popularity: Double
        let posterPath: String?
        let productionCompanies: [ProductionCompany]
        let productionCountries: [ProductionCountry]
        let releaseDate: String?         // ISO date string ("YYYY-MM-DD")
        let revenue: Int
        let runtime: Int?
        let spokenLanguages: [SpokenLanguage]
        let status: String?
        let tagline: String?
        let title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int

        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case belongsToCollection = "belongs_to_collection"
            case budget
            case genres
            case homepage
            case id
            case imdbID = "imdb_id"
            case originCountry = "origin_country"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview
            case popularity
            case posterPath = "poster_path"
            case productionCompanies = "production_companies"
            case productionCountries = "production_countries"
            case releaseDate = "release_date"
            case revenue
            case runtime
            case spokenLanguages = "spoken_languages"
            case status
            case tagline
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

    struct BelongsToCollection: Codable {
        let id: Int?
        let name: String?
        let posterPath: String?
        let backdropPath: String?

        enum CodingKeys: String, CodingKey {
            case id, name
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
        }
    }

    struct Genre: Codable {
        let id: Int
        let name: String
    }

    struct ProductionCompany: Codable {
        let id: Int
        let logoPath: String?
        let name: String
        let originCountry: String?

        enum CodingKeys: String, CodingKey {
            case id, name
            case logoPath = "logo_path"
            case originCountry = "origin_country"
        }
    }

    struct ProductionCountry: Codable {
        let iso3166_1: String
        let name: String

        enum CodingKeys: String, CodingKey {
            case iso3166_1 = "iso_3166_1"
            case name
        }
    }

    struct SpokenLanguage: Codable {
        let englishName: String?
        let iso639_1: String?
        let name: String?

        enum CodingKeys: String, CodingKey {
            case englishName = "english_name"
            case iso639_1 = "iso_639_1"
            case name
        }
    }
}

// MARK: - Convenience helpers
extension TheMovieDetail.Response {
    /// Build full URL for poster using a base (for example: "https://image.tmdb.org/t/p/w500")
    func posterURL(base: String) -> URL? {
        guard let path = posterPath else { return nil }
        return URL(string: base + path)
    }

    /// Build full URL for backdrop using a base (for example: "https://image.tmdb.org/t/p/w780")
    func backdropURL(base: String) -> URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: base + path)
    }

    /// Convert releaseDate string ("YYYY-MM-DD") to Date if possible.
    func releaseDateAsDate() -> Date? {
        guard let releaseDate = releaseDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: releaseDate)
    }
}
