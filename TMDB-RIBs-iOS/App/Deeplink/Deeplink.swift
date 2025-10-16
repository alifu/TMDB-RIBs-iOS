//
//  Deeplink.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 16/10/25.
//

import Foundation

enum Deeplink {
    case movieDetail(id: Int)
    case search(query: String)
    case tab(tab: String)
    
    init?(url: URL) {
        guard let host = url.host else { return nil }

        switch host {
        case "movie":
            if let idString = url.pathComponents.dropFirst().first,
               let id = Int(idString) {
                self = .movieDetail(id: id)
            } else {
                return nil
            }
        case "search":
            if let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "query" })?
                .value {
                self = .search(query: query)
            } else {
                return nil
            }
        case "tab":
            if let tab = url.pathComponents.dropFirst().first {
                self = .tab(tab: tab)
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}
