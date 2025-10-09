//
//  TheMovieDetailReview.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 08/10/25.
//

import Foundation
import RxDataSources

struct TheMovieReview {

    struct Response: Codable {
        let id: Int
        let page: Int
        let results: [Result]
        let totalPages: Int
        let totalResults: Int

        enum CodingKeys: String, CodingKey {
            case id
            case page
            case results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    }

    struct Result: Codable {
        let author: String
        let authorDetails: AuthorDetails
        let content: String
        let createdAt: String
        let id: String
        let updatedAt: String
        let url: String

        enum CodingKeys: String, CodingKey {
            case author
            case authorDetails = "author_details"
            case content
            case createdAt = "created_at"
            case id
            case updatedAt = "updated_at"
            case url
        }
    }

    struct AuthorDetails: Codable {
        let name: String?
        let username: String?
        let avatarPath: String?
        let rating: Double?

        enum CodingKeys: String, CodingKey {
            case name
            case username
            case avatarPath = "avatar_path"
            case rating
        }
    }
}

struct SectionOfMovieReview {
    var header: String
    var items: [TheMovieReview.Result]
}

extension SectionOfMovieReview: SectionModelType {
    init(original: SectionOfMovieReview, items: [TheMovieReview.Result]) {
        self = original
        self.items = items
    }
}
