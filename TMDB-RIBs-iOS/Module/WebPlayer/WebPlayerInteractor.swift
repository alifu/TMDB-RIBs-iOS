//
//  WebPlayerInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol WebPlayerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol WebPlayerPresentable: Presentable {
    var listener: WebPlayerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindURL(_ url: Observable<URL?>)
}

protocol WebPlayerListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func goBackFromWebPlayer()
}

final class WebPlayerInteractor: PresentableInteractor<WebPlayerPresentable>, WebPlayerInteractable, WebPlayerPresentableListener {

    weak var router: WebPlayerRouting?
    weak var listener: WebPlayerListener?
    private let url: URL
    private let currentURL = BehaviorRelay<URL?>(value: nil)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: WebPlayerPresentable,
        url: URL
    ) {
        self.url = url
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.bindURL(currentURL.asObservable())
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension WebPlayerInteractor {
    
    func goBack() {
        self.listener?.goBackFromWebPlayer()
    }
    
    func loadURL() {
        currentURL.accept(url)
    }
}
