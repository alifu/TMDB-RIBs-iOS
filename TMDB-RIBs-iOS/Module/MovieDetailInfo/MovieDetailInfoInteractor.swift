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
    func bindSelectedTab(_ data: Observable<MovieDetailInfoType>)
    func bindAboutMovie(_ data: Observable<String?>)
    func bindMovieReviews(_ data: Observable<[TheMovieReview.Result]>)
    func bindMovieCredits(_ data: Observable<[TheMovieCredit.Cast]>)
    func loading(_ isLoading: Observable<Bool>)
    func errorViewVisible(_ model: Observable<ErrorViewModel?>)
}

protocol MovieDetailInfoListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MovieDetailInfoInteractor: PresentableInteractor<MovieDetailInfoPresentable>, MovieDetailInfoInteractable, MovieDetailInfoPresentableListener {

    weak var router: MovieDetailInfoRouting?
    weak var listener: MovieDetailInfoListener?
    private let apiManager: APIManager
    private let withMovieId: Int
    private let aboutMovieRelay: BehaviorRelay<String?>
    private var tabType: BehaviorRelay<MovieDetailInfoType> = .init(value: .aboutMovie)
    private var movieReviews: BehaviorRelay<[TheMovieReview.Result]> = .init(value: [])
    private var movieCredits: BehaviorRelay<[TheMovieCredit.Cast]> = .init(value: [])
    private var isLoading = PublishRelay<Bool>()
    private let errorState = BehaviorRelay<ErrorViewModel?>(value: nil)
    private let selectedMiniTabRelay: PublishRelay<(IndexPath, MiniTab)>

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
        self.selectedMiniTabRelay = dependency.selectedMiniTabRelay
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.loading(isLoading.asObservable())
        self.presenter.bindSelectedTab(tabType.asObservable())
        self.presenter.bindAboutMovie(aboutMovieRelay.asObservable())
        self.presenter.bindMovieReviews(movieReviews.asObservable())
        self.presenter.bindMovieCredits(movieCredits.asObservable())
        self.presenter.errorViewVisible(errorState.asObservable())
        bindMiniTab()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func bindMiniTab() {
        selectedMiniTabRelay
            .distinctUntilChanged { lhs, rhs in
                lhs.1 == rhs.1  // compare MiniTab only
            }
            .subscribe { [weak self] indexPath, miniTab in
                guard let `self` = self else { return }
                if case .movieDetail(let tab) = miniTab {
                    self.didSelectTab(indexPath, item: tab)
                }
            }
            .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchMovieReviews() {
        isLoading.accept(true)
        errorState.accept(nil)
        apiManager.fetchMovieReviews(id: withMovieId).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                if response.totalResults == 0 {
                    self.emptyData(from: "review")
                } else {
                    self.movieReviews.accept(response.results)
                }
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func fetchMovieCredits() {
        isLoading.accept(true)
        errorState.accept(nil)
        apiManager.fetchMovieCredits(id: withMovieId).subscribe(
            onSuccess: { [weak self] response in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                if response.cast.isEmpty {
                    self.emptyData(from: "cast")
                } else {
                    self.movieCredits.accept(response.cast)
                }
            },
            onFailure: { [weak self] error in
                guard let `self` = self else { return }
                self.isLoading.accept(false)
                print("❌ API Error:", error)
            }
        )
        .disposeOnDeactivate(interactor: self)
    }
    
    private func emptyData(from info: String) {
        errorState.accept(
            ErrorViewModel(
                image: UIImage(named: "empty-box"),
                title: "There is no \(info) yet!",
                subtitle: ""
            )
        )
    }
    
    private func didSelectTab(_ indexPath: IndexPath, item: TheMovieDetailInfo.Tab) {
        tabType.accept(item.type)
        errorState.accept(nil)
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

extension MovieDetailInfoInteractor {
    
    
}
