//
//  MainTabBarViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 24/09/25.
//

import RIBs
import RxSwift
import UIKit

protocol MainTabBarPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainTabBarViewController: UITabBarController, MainTabBarPresentable, MainTabBarViewControllable {
    
    weak var listener: MainTabBarPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.primary
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.setViewControllers(viewControllers, animated: false)
    }
    
    @available(iOS 26.0, *)
    func setTabs(_ tabs: [UITab]) {
        self.setTabs(tabs, animated: false)
    }
}
