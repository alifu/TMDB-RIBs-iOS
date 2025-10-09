//
//  TheMovieAccountStates.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 09/10/25.
//

struct TheMovieAccountStates {
    
    struct Response: Decodable {
        let id: Int
        let favorite: Bool
        let watchlist: Bool
        let rated: Rated
    }
    
    enum Rated: Decodable {
        case bool(Bool)
        case value(Double)
        
        var isRated: Bool {
            switch self {
            case .bool(let v): return v
            case .value: return true
            }
        }
        
        var ratingValue: Double? {
            switch self {
            case .bool: return nil
            case .value(let v): return v
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            // Try decode as Bool
            if let boolValue = try? container.decode(Bool.self) {
                self = .bool(boolValue)
                return
            }
            
            // Try decode as object { "value": Double }
            if let ratedObj = try? container.decode([String: Double].self),
               let value = ratedObj["value"] {
                self = .value(value)
                return
            }
            
            // Fallback if none works
            throw DecodingError.typeMismatch(
                Rated.self,
                .init(codingPath: decoder.codingPath, debugDescription: "Invalid rated value type")
            )
        }
    }
}
