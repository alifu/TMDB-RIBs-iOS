//
//  TheMovieCredit.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 08/10/25.
//

import Foundation
import RxDataSources

struct TheMovieCredit {

    struct Response: Codable {
        let id: Int
        let cast: [Cast]
    }

    struct Cast: Codable {
        let adult: Bool
        let gender: Int?
        let id: Int
        let knownForDepartment: String?
        let name: String
        let originalName: String?
        let popularity: Double?
        let profilePath: String?
        let castId: Int?
        let character: String?
        let creditId: String?
        let order: Int?
        
        enum CodingKeys: String, CodingKey {
            case adult
            case gender
            case id
            case knownForDepartment = "known_for_department"
            case name
            case originalName = "original_name"
            case popularity
            case profilePath = "profile_path"
            case castId = "cast_id"
            case character
            case creditId = "credit_id"
            case order
        }
    }
}

struct SectionOfMovieCredit {
    var header: String
    var items: [TheMovieCredit.Cast]
}

extension SectionOfMovieCredit: SectionModelType {
    init(original: SectionOfMovieCredit, items: [TheMovieCredit.Cast]) {
        self = original
        self.items = items
    }
}
