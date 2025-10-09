//
//  MovieDetailInfoInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 08/10/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol MovieDetailInfoRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MovieDetailInfoPresentable: Presentable {
    var listener: MovieDetailInfoPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindTab(_ data: Observable<[TheMovieDetailInfo.Tab]>)
    func bindSelectedTab(_ data: Observable<MovieDetailInfoType>)
    func bindAboutMovie(_ data: Observable<String?>)
    func bindMovieReviews(_ data: Observable<[TheMovieReview.Result]>)
    func bindMovieCredits(_ data: Observable<[TheMovieCredit.Cast]>)
}

protocol MovieDetailInfoListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MovieDetailInfoInteractor: PresentableInteractor<MovieDetailInfoPresentable>, MovieDetailInfoInteractable, MovieDetailInfoPresentableListener {

    weak var router: MovieDetailInfoRouting?
    weak var listener: MovieDetailInfoListener?
    private let apiManager: APIManager
    private let withMovieId: Int
    private var movieInfoTab: BehaviorRelay<[TheMovieDetailInfo.Tab]> = .init(value: theMovieDetailInfo)
    private var movieInfoTabData = theMovieDetailInfo
    private let aboutMovieRelay: BehaviorRelay<String?>
    private var tabType: BehaviorRelay<MovieDetailInfoType> = .init(value: .aboutMovie)
    private var movieReviews: BehaviorRelay<[TheMovieReview.Result]> = .init(value: [])
    private var movieCredits: BehaviorRelay<[TheMovieCredit.Cast]> = .init(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MovieDetailInfoPresentable,
        dependency: MovieDetailInfoDependency,
        apiManager: APIManager,
        withMovieId: Int
    ) {
        self.apiManager = apiManager
        self.withMovieId = withMovieId
        self.aboutMovieRelay = dependency.aboutMovieRelay
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.bindTab(movieInfoTab.asObservable())
        self.presenter.bindSelectedTab(tabType.asObservable())
        self.presenter.bindAboutMovie(aboutMovieRelay.asObservable())
        self.presenter.bindMovieReviews(movieReviews.asObservable())
        self.presenter.bindMovieCredits(movieCredits.asObservable())
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchMovieReviews() {
        apiManager.fetchMovieReviews(id: withMovieId).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                self.movieReviews.accept(response.results)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchMovieCredits() {
        apiManager.fetchMovieCredits(id: withMovieId).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                self.movieCredits.accept(response.cast)
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
}

extension MovieDetailInfoInteractor {
    
    func didSelectTab(_ indexPath: IndexPath, item: TheMovieDetailInfo.Tab) {
        movieInfoTabData.select(id: item.id)
        movieInfoTab.accept(movieInfoTabData)
        tabType.accept(item.type)
        switch item.type {
        case .cast:
            if !movieCredits.value.isEmpty { return }
            fetchMovieCredits()
        case .reviews:
            if !movieReviews.value.isEmpty { return }
            fetchMovieReviews()
        case .aboutMovie:
            break
        }
    }
}
