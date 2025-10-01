//
//  ViewControllerWrapper.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 30/09/25.
//

import RIBs
import UIKit

final class ViewControllerWrapper: UIViewController {
    private let wrapped: ViewControllable

    init(_ wrapped: ViewControllable) {
        self.wrapped = wrapped
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let child = wrapped.uiviewController
        addChild(child)
        child.view.frame = view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
