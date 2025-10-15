//
//  CarouselMovieInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 14/10/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol CarouselMovieRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CarouselMoviePresentable: Presentable {
    var listener: CarouselMoviePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindCarousel(_ movies: Observable<[TheMovieCaraousel]>)
}

protocol CarouselMovieListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func openVideoWith(url: URL)
}

final class CarouselMovieInteractor: PresentableInteractor<CarouselMoviePresentable>, CarouselMovieInteractable, CarouselMoviePresentableListener {

    weak var router: CarouselMovieRouting?
    weak var listener: CarouselMovieListener?
    private let carouselMovieItems: BehaviorRelay<[TheMovieCaraousel]>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CarouselMoviePresentable,
        dependency: CarouselMovieDependency
    ) {
        self.carouselMovieItems = dependency.carouselMovieItems
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.bindCarousel(carouselMovieItems.asObservable())
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension CarouselMovieInteractor {
    
    func didSelectVideo(url: URL) {
        self.listener?.openVideoWith(url: url)
    }
}
