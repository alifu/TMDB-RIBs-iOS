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
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension MovieDetailInfoInteractor {
    
    func didSelectTab(_ indexPath: IndexPath, item: TheMovieDetailInfo.Tab) {
        movieInfoTabData.select(id: item.id)
        movieInfoTab.accept(movieInfoTabData)
        tabType.accept(item.type)
    }
}
