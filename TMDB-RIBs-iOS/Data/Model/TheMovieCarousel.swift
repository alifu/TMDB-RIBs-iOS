//
//  TheMovieCarousel.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 14/10/25.
//

import Foundation
import RxDataSources

enum TheMovieCarousel: IdentifiableType, Equatable {
    case backdrop(URL?)
    case video(TheMovieVideo.Result)
    
    // MARK: - Computed Properties
    
    var imageURL: URL? {
        switch self {
        case .backdrop(let url):
            return url
        case .video(let video):
            return video.thumbnailURL
        }
    }
    
    var title: String? {
        switch self {
        case .backdrop:
            return nil
        case .video(let video):
            return video.name
        }
    }
    
    // MARK: - IdentifiableType
    
    var identity: String {
        switch self {
        case .backdrop(let url):
            return "backdrop-\(url?.absoluteString ?? UUID().uuidString)"
        case .video(let video):
            return "video-\(video.id)"
        }
    }
    
    // MARK: - Equatable
    
    static func == (lhs: TheMovieCarousel, rhs: TheMovieCarousel) -> Bool {
        switch (lhs, rhs) {
        case (.backdrop(let lURL), .backdrop(let rURL)):
            return lURL == rURL
        case (.video(let lVideo), .video(let rVideo)):
            return lVideo.id == rVideo.id
        default:
            return false
        }
    }
}

struct SectionOfMovieCarousel: AnimatableSectionModelType {
    var header: String
    var items: [TheMovieCarousel]
    
    var identity: String { header }
    
    init(header: String, items: [TheMovieCarousel]) {
        self.header = header
        self.items = items
    }
    
    init(original: SectionOfMovieCarousel, items: [TheMovieCarousel]) {
        self = original
        self.items = items
    }
}
