//
//  MainTabBarInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 24/09/25.
//

import RIBs
import RxSwift

protocol MainTabBarRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachTabs()
}

protocol MainTabBarPresentable: Presentable {
    var listener: MainTabBarPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainTabBarListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainTabBarInteractor: PresentableInteractor<MainTabBarPresentable>, MainTabBarInteractable, MainTabBarPresentableListener {

    weak var router: MainTabBarRouting?
    weak var listener: MainTabBarListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MainTabBarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
