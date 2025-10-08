//
//  WatchListViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa
import RxSwift
import SnapKit
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
        self.navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private let headerView: HeaderBar = {
        let view = HeaderBar()
        view.backgroundColor = .clear
        view.setupContent(titleText: "Watch List")
        return view
    }()
    
    private func setupUI() {
        self.view.addSubview(headerView)
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
