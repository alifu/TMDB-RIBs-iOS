//
//  MiniTabInteractor.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit

protocol MiniTabRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MiniTabPresentable: Presentable {
    var listener: MiniTabPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func bindMiniTab(_ data: Observable<[MiniTab]>)
}

protocol MiniTabListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func selectedMiniTab(_ indexPath: IndexPath, item: MiniTab)
}

final class MiniTabInteractor: PresentableInteractor<MiniTabPresentable>, MiniTabInteractable, MiniTabPresentableListener {

    weak var router: MiniTabRouting?
    weak var listener: MiniTabListener?
    private let miniTab: [MiniTab]
    private var miniTabRelay: BehaviorRelay<[MiniTab]> = .init(value: [])

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: MiniTabPresentable,
        miniTab: [MiniTab]
    ) {
        self.miniTab = miniTab
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        self.presenter.bindMiniTab(miniTabRelay.asObservable())
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension MiniTabInteractor {
    
    func didLoadTab() {
        miniTabRelay.accept(miniTab)
    }
    
    func didSelectTab(_ indexPath: IndexPath, item: MiniTab) {
        var selectedID = 0
        switch item {
        case .movieList(let data):
            selectedID = data.id
        case .movieDetail(let data):
            selectedID = data.id
        }
        let currentData = miniTabRelay.value.selecting(id: selectedID)
        miniTabRelay.accept(currentData)
        self.listener?.selectedMiniTab(indexPath, item: item)
    }
}
