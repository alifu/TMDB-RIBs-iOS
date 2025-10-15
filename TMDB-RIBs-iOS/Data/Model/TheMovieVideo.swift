//
//  TheMovieVideo.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 14/10/25.
//

import Foundation
import RxDataSources

struct TheMovieVideo {
    
    struct Request {
        let page: Int
        let language: String
        let includeAdult: Bool
        let query: String
    }
    
    struct Response: Decodable {
        let id: Int
        let results: [Result]
        
        enum CodingKeys: String, CodingKey {
            case id
            case results
        }
    }
    
    struct Result: Identifiable, Decodable {
        let iso639_1: String
        let iso3166_1: String
        let name: String
        let key: String
        let site: String
        let size: Int
        let official: Bool
        let type: String
        let id: String
        let publishedAt: String
        
        enum CodingKeys: String, CodingKey {
            case iso639_1 = "iso_639_1"
            case iso3166_1 = "iso_3166_1"
            case name
            case key
            case site
            case size
            case official
            case type
            case publishedAt = "published_at"
            case id
        }
        
        var videoURL: URL? {
            switch site.lowercased() {
            case "youtube":
                return URL(string: "https://www.youtube.com/watch?v=\(key)")
            case "vimeo":
                return URL(string: "https://vimeo.com/\(key)")
            case "dailymotion":
                return URL(string: "https://www.dailymotion.com/video/\(key)")
            case "apple":
                return URL(string: "https://trailers.apple.com/trailers/\(key)")
            default:
                return nil
            }
        }
        
        var thumbnailURL: URL? {
            switch site.lowercased() {
            case "youtube":
                // Highest-quality thumbnail if available
                return URL(string: "https://img.youtube.com/vi/\(key)/maxresdefault.jpg")
                ?? URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
                
            case "vimeo":
                // Vimeo thumbnails require API call for full quality,
                // but there’s a predictable CDN pattern for public videos:
                return URL(string: "https://vumbnail.com/\(key).jpg")
                
            case "dailymotion":
                return URL(string: "https://www.dailymotion.com/thumbnail/video/\(key)")
                
            case "apple":
                // Apple trailers don’t expose thumbnails publicly — use a placeholder
                return URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video118/v4/placeholder.jpg")
                
            default:
                return nil
            }
        }
    }
}

struct SectionOfVideoMovie {
    var header: String
    var items: [TheMovieVideo.Result]
}

extension SectionOfVideoMovie: SectionModelType {
    init(original: SectionOfVideoMovie, items: [TheMovieVideo.Result]) {
        self = original
        self.items = items
    }
}
