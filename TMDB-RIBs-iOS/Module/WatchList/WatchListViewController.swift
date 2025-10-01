//
//  WatchListViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 30/09/25.
//

import RIBs
import RxSwift
import UIKit

protocol WatchListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class WatchListViewController: UIViewController, WatchListPresentable, WatchListViewControllable {

    weak var listener: WatchListPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.primary
    }
}
