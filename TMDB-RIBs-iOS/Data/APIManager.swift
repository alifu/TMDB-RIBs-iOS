//
//  APIManager.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 01/10/25.
//

import Foundation
import Moya
import RxMoya
import RxSwift

enum TheMovieAPI {
    
    case trendingToday(request: TheMovieTrendingToday.Request, isLocal: Bool = false)
    case popular(request: TheMoviePopular.Request, isLocal: Bool = false)
    case nowPlaying(request: TheMovieNowPlaying.Request, isLocal: Bool = false)
    case upComing(request: TheMovieUpComing.Request, isLocal: Bool = false)
    case topRated(request: TheMovieTopRated.Request, isLocal: Bool = false)
    case searchMovie(request: TheMovieSearch.Request, isLocal: Bool = false)
    case movieDetail(id: Int, isLocal: Bool = false)
    case movieAccountStates(id: Int, isLocal: Bool = false)
    case movieReview(id: Int, isLocal: Bool = false)
    case movieCredit(id: Int, isLocal: Bool = false)
    case postWatchList(request: TheMovieWatchListPost.Request, isLocal: Bool = false)
    case movieWatchList(request: TheMovieWatchList.Request, isLocal: Bool = false)
    case movieVideo(id: Int, isLocal: Bool = false)
}

extension TheMovieAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .trendingToday(_, let isLocal),
                .popular(_, let isLocal),
                .nowPlaying(_, let isLocal),
                .upComing(_, let isLocal),
                .topRated(_, let isLocal),
                .searchMovie(_, let isLocal),
                .movieDetail(_, let isLocal),
                .movieAccountStates(_, let isLocal),
                .movieReview(_, let isLocal),
                .movieCredit(_, let isLocal),
                .postWatchList(_, let isLocal),
                .movieWatchList(_, let isLocal),
                .movieVideo(_, let isLocal):
            
            if isLocal {
                return URL(string: Natrium.Config.baseUrlLocal)!
            } else {
                return URL(string: Natrium.Config.baseUrl)!
            }
        }
    }
    var path: String {
        switch self {
        case .trendingToday:
            return "/trending/movie/day"
        case .popular:
            return "/movie/popular"
        case .nowPlaying:
            return "/movie/now_playing"
        case .upComing:
            return "/movie/upcoming"
        case .topRated:
            return "/movie/top_rated"
        case .searchMovie:
            return "/search/movie"
        case .movieDetail(let id, _):
            return "/movie/\(id)"
        case .movieAccountStates(let id, _):
            return "/movie/\(id)/account_states"
        case .movieReview(let id, _):
            return "/movie/\(id)/reviews"
        case .movieCredit(let id, _):
            return "/movie/\(id)/credits"
        case .postWatchList:
            return "/account/\(Natrium.Config.accountID)/watchlist"
        case .movieWatchList:
            return "/account/\(Natrium.Config.accountID)/watchlist/movies"
        case .movieVideo(let id, _):
            return "/movie/\(id)/videos"
        }
    }
    var method: Moya.Method {
        switch self {
        case .postWatchList:
            return .post
        default:
            return .get
            
        }
    }
    var sampleData: Data { Data() }
    var task: Task {
        switch self {
        case .trendingToday(let request, _):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        case .popular(let request, _):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        case .nowPlaying(let request, _):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        case .upComing(let request, _):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        case .topRated(let request, _):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        case .searchMovie(let request, _):
            return .requestParameters(
                parameters: [
                    "language": request.language,
                    "page": request.page,
                    "include_adult": request.includeAdult,
                    "query": request.query
                ],
                encoding: URLEncoding.default
            )
        case .movieDetail(_, _):
            return .requestParameters(
                parameters: ["language": "en-US"],
                encoding: URLEncoding.default
            )
        case .movieAccountStates(_, _):
            return .requestParameters(
                parameters: ["language": "en-US"],
                encoding: URLEncoding.default
            )
        case .movieReview(_, _):
            return .requestParameters(
                parameters: ["language": "en-US"],
                encoding: URLEncoding.default
            )
        case .movieCredit(_, _):
            return .requestParameters(
                parameters: ["language": "en-US"],
                encoding: URLEncoding.default
            )
        case .postWatchList(let request, _):
            return .requestCompositeParameters(
                bodyParameters: [
                    "media_type": request.mediaType,
                    "media_id": request.mediaId,
                    "watchlist": request.watchlist,
                ],
                bodyEncoding: JSONEncoding.default,
                urlParameters: [:]
            )
        case .movieWatchList(let request, _):
            return .requestParameters(
                parameters: ["language": request.language, "page": request.page],
                encoding: URLEncoding.default
            )
        case .movieVideo(_, _):
            return .requestParameters(
                parameters: ["language": "en-US"],
                encoding: URLEncoding.default
            )
        }
    }
    var headers: [String : String]? {
        return [
            "accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(Natrium.Config.token)"
        ]
    }
}

protocol TheMovieProtocol {
    
    func fetchTrendingTodayMovie(request: TheMovieTrendingToday.Request, isLocal: Bool) -> Single<TheMovieTrendingToday.Response>
    func fetchPopularMovie(request: TheMoviePopular.Request, isLocal: Bool) -> Single<TheMoviePopular.Response>
    func fetchNowPlayingMovie(request: TheMovieNowPlaying.Request, isLocal: Bool) -> Single<TheMovieNowPlaying.Response>
    func fetchUpComingMovie(request: TheMovieUpComing.Request, isLocal: Bool) -> Single<TheMovieUpComing.Response>
    func fetchTopRatedMovie(request: TheMovieTopRated.Request, isLocal: Bool) -> Single<TheMovieTopRated.Response>
    func fetchSearchMovie(request: TheMovieSearch.Request, isLocal: Bool) -> Single<TheMovieSearch.Response>
    func fetchMovieDetail(id: Int, isLocal: Bool) -> Single<TheMovieDetail.Response>
    func fetchMovieAccountStates(id: Int, isLocal: Bool) -> Single<TheMovieAccountStates.Response>
    func fetchMovieDetailWithStates(id: Int, isLocal: Bool) -> Observable<TheMovieDetail.Response>
    func fetchMovieReviews(id: Int, isLocal: Bool) -> Single<TheMovieReview.Response>
    func fetchMovieCredits(id: Int, isLocal: Bool) -> Single<TheMovieCredit.Response>
    func fetchSearchMovieWithDetails(request: TheMovieSearch.Request, isLocal: Bool) -> Single<[MovieItem]>
    func postWatchList(request: TheMovieWatchListPost.Request, isLocal: Bool) -> Single<TheMovieWatchListPost.Response>
    func fetchMovieWatchList(request: TheMovieWatchList.Request, isLocal: Bool) -> Single<TheMovieWatchList.Response>
}

struct APIManager {
    
    static let shared = APIManager()
    static let provider = MoyaProvider<TheMovieAPI>()
    private let disposeBag = DisposeBag()
    
    private init() {}
}

extension APIManager: TheMovieProtocol {
    
    func fetchTrendingTodayMovie(request: TheMovieTrendingToday.Request, isLocal: Bool = false) -> Single<TheMovieTrendingToday.Response> {
        return APIManager.provider.rx
            .request(.trendingToday(request: request, isLocal: isLocal))
            .map(TheMovieTrendingToday.Response.self)
    }
    
    func fetchPopularMovie(request: TheMoviePopular.Request, isLocal: Bool = false) -> Single<TheMoviePopular.Response> {
        return APIManager.provider.rx
            .request(.popular(request: request, isLocal: isLocal))
            .map(TheMoviePopular.Response.self)
    }
    
    func fetchNowPlayingMovie(request: TheMovieNowPlaying.Request, isLocal: Bool = false) -> Single<TheMovieNowPlaying.Response> {
        return APIManager.provider.rx
            .request(.nowPlaying(request: request, isLocal: isLocal))
            .map(TheMovieNowPlaying.Response.self)
    }
    
    func fetchUpComingMovie(request: TheMovieUpComing.Request, isLocal: Bool = false) -> Single<TheMovieUpComing.Response> {
        return APIManager.provider.rx
            .request(.upComing(request: request, isLocal: isLocal))
            .map(TheMovieUpComing.Response.self)
    }
    
    func fetchTopRatedMovie(request: TheMovieTopRated.Request, isLocal: Bool = false) -> Single<TheMovieTopRated.Response> {
        return APIManager.provider.rx
            .request(.topRated(request: request, isLocal: isLocal))
            .map(TheMovieTopRated.Response.self)
    }
    
    func fetchSearchMovie(request: TheMovieSearch.Request, isLocal: Bool = false) -> Single<TheMovieSearch.Response> {
        return APIManager.provider.rx
            .request(.searchMovie(request: request, isLocal: isLocal))
            .map(TheMovieSearch.Response.self)
    }
    
    func fetchMovieDetail(id: Int, isLocal: Bool = false) -> Single<TheMovieDetail.Response> {
        APIManager.provider.rx
            .request(.movieDetail(id: id, isLocal: isLocal))
            .map(TheMovieDetail.Response.self)
    }
    
    func fetchMovieAccountStates(id: Int, isLocal: Bool = false) -> Single<TheMovieAccountStates.Response> {
        APIManager.provider.rx
            .request(.movieAccountStates(id: id, isLocal: isLocal))
            .map(TheMovieAccountStates.Response.self)
    }
    
    func fetchMovieDetailWithStates(id: Int, isLocal: Bool = false) -> Observable<TheMovieDetail.Response> {
        let subject = PublishSubject<TheMovieDetail.Response>()
        
        APIManager.provider.rx
            .request(.movieDetail(id: id, isLocal: isLocal))
            .map(TheMovieDetail.Response.self)
            .subscribe(onSuccess: { detail in
                // Emit detail immediately
                subject.onNext(detail)
                
                // Then continue fetching state and video
                Single.zip(
                    APIManager.provider.rx
                        .request(.movieAccountStates(id: id, isLocal: isLocal))
                        .map(TheMovieAccountStates.Response.self),
                    APIManager.provider.rx
                        .request(.movieVideo(id: id, isLocal: isLocal))
                        .map(TheMovieVideo.Response.self)
                )
                .subscribe(onSuccess: { state, video in
                    var updatedDetail = detail
                    updatedDetail.accountStates = state
                    updatedDetail.videos = video
                    subject.onNext(updatedDetail)
                    subject.onCompleted()
                }, onFailure: { error in
                    subject.onError(error)
                })
                .disposed(by: disposeBag)
                
            }, onFailure: { error in
                subject.onError(error)
            })
            .disposed(by: disposeBag)
        
        return subject.asObservable()
    }
    
    func fetchMovieReviews(id: Int, isLocal: Bool = false) -> Single<TheMovieReview.Response> {
        APIManager.provider.rx
            .request(.movieReview(id: id, isLocal: isLocal))
            .map(TheMovieReview.Response.self)
    }
    
    func fetchMovieCredits(id: Int, isLocal: Bool = false) -> Single<TheMovieCredit.Response> {
        APIManager.provider.rx
            .request(.movieCredit(id: id, isLocal: isLocal))
            .map(TheMovieCredit.Response.self)
    }
    
    func fetchSearchMovieWithDetails(request: TheMovieSearch.Request, isLocal: Bool = false) -> Single<[MovieItem]> {
        return fetchSearchMovie(request: request, isLocal: isLocal)
            .flatMap { response -> Single<[MovieItem]> in
                let detailSingles = response.results.map { movie in
                    self.fetchMovieDetail(id: movie.id, isLocal: isLocal)
                        .map { detail -> MovieItem in
                            MovieItem(
                                id: movie.id,
                                title: movie.title,
                                posterURL: movie.posterPath.map { $0 },
                                rating: movie.voteAverage,
                                releaseYear: movie.releaseYear,
                                runtime: detail.runtime ?? 0,
                                genres: detail.genres.map { $0.name }
                            )
                        }
                }
                return Single.zip(detailSingles)
            }
    }
    
    func postWatchList(request: TheMovieWatchListPost.Request, isLocal: Bool = false) -> Single<TheMovieWatchListPost.Response> {
        APIManager.provider.rx
            .request(.postWatchList(request: request, isLocal: isLocal))
            .map(TheMovieWatchListPost.Response.self)
    }
    
    func fetchMovieWatchList(request: TheMovieWatchList.Request, isLocal: Bool = false) -> Single<TheMovieWatchList.Response> {
        APIManager.provider.rx
            .request(.movieWatchList(request: request, isLocal: isLocal))
            .map(TheMovieWatchList.Response.self)
    }
}
