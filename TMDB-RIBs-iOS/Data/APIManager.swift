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

enum TheMovieAPI {
    
    case popular(request: TheMoviePopular.Request)
    case nowPlaying(request: TheMovieNowPlaying.Request)
    case upComing(request: TheMovieUpComing.Request)
    case topRated(request: TheMovieTopRated.Request)
}

extension TheMovieAPI: TargetType {
    
    var baseURL: URL { URL(string: Natrium.Config.baseUrl)! }
    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .nowPlaying:
            return "/movie/now_playing"
        case .upComing:
            return "/movie/upcoming"
        case .topRated:
            return "/movie/top_rated"
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
        case .nowPlaying(let request):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        case .upComing(let request):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        case .topRated(let request):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        }
    }
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(Natrium.Config.token)"
        ]
    }
}

protocol TheMovieProtocol {
    
    func fetchPopularMovie(request: TheMoviePopular.Request) -> Single<TheMoviePopular.Response>
    func fetchNowPlayingMovie(request: TheMovieNowPlaying.Request) -> Single<TheMovieNowPlaying.Response>
    func fetchUpComingMovie(request: TheMovieUpComing.Request) -> Single<TheMovieUpComing.Response>
    func fetchTopRatedMovie(request: TheMovieTopRated.Request) -> Single<TheMovieTopRated.Response>
}

struct APIManager {
    
    static let shared = APIManager()
    static let provider = MoyaProvider<TheMovieAPI>()
    
    private init() {}
}

extension APIManager: TheMovieProtocol {
    
    func fetchPopularMovie(request: TheMoviePopular.Request) -> Single<TheMoviePopular.Response> {
        return APIManager.provider.rx
            .request(.popular(request: request))
            .map(TheMoviePopular.Response.self)
    }
    
    func fetchNowPlayingMovie(request: TheMovieNowPlaying.Request) -> Single<TheMovieNowPlaying.Response> {
        return APIManager.provider.rx
            .request(.nowPlaying(request: request))
            .map(TheMovieNowPlaying.Response.self)
    }
    
    func fetchUpComingMovie(request: TheMovieUpComing.Request) -> Single<TheMovieUpComing.Response> {
        return APIManager.provider.rx
            .request(.upComing(request: request))
            .map(TheMovieUpComing.Response.self)
    }
    
    func fetchTopRatedMovie(request: TheMovieTopRated.Request) -> Single<TheMovieTopRated.Response> {
        return APIManager.provider.rx
            .request(.topRated(request: request))
            .map(TheMovieTopRated.Response.self)
    }
}
