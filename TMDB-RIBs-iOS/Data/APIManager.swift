//
//  APIManager.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 01/10/25.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum APIEnvironment {
    case production
    case local
    
    var baseURL: URL {
        switch self {
        case .production:
            return URL(string: "https://api.themoviedb.org/3")!
        case .local:
            return URL(string: "http://localhost:3003")!
        }
    }
}

enum TheMovieAPI {
    
    case popular(request: TheMoviePopular.Request)
}

extension TheMovieAPI: TargetType {
    
    var baseURL: URL { APIManager.environment.baseURL }
    var path: String {
        switch self {
        case .popular:
            return "/discover/movie"
        }
    }
    var method: Moya.Method { .get }
    var sampleData: Data { Data() }
    var task: Task {
        switch self {
        case .popular(let request):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        }
    }
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(APIManager.apiToken)"
        ]
    }
}

protocol TheMovieProtocol {
    
    func fetchPopularMovie(request: TheMoviePopular.Request) -> Single<TheMoviePopular.Response>
}

struct APIManager {
    
    static let shared = APIManager()
    static var environment: APIEnvironment = .production
    static let provider = MoyaProvider<TheMovieAPI>()
    
    static var apiToken: String {
        switch environment {
        case .production:
            return ""
        case .local:
            return ""
        }
    }
    
    private init() {}
}

extension APIManager: TheMovieProtocol {
    
    func fetchPopularMovie(request: TheMoviePopular.Request) -> Single<TheMoviePopular.Response> {
        return APIManager.provider.rx
            .request(.popular(request: request))
            .map(TheMoviePopular.Response.self)
    }
}
