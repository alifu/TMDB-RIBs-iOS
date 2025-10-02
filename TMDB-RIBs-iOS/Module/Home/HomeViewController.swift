//
//  HomeViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxSwift
import SnapKit
import UIKit

protocol HomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    weak var listener: HomePresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.primary
        self.navigationController?.navigationBar.isHidden = true
        
        setupUI()
    }
    
    // MARK: - Private
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What do you want to watch?"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let searchBox: SearchBox = {
        let searchBox = SearchBox()
        return searchBox
    }()
    
    private let popularMoviewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private func setupUI() {
        self.view.addSubview(headerTitleLabel)
        self.view.addSubview(searchBox)
        self.view.addSubview(popularMoviewContainer)
        
        headerTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        searchBox.snp.makeConstraints {
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        popularMoviewContainer.snp.makeConstraints {
            $0.top.equalTo(searchBox.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
}

extension HomeViewController {
    
    func attachPopularMovieView(viewController: (any ViewControllable)?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            popularMoviewContainer.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.uiviewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.uiviewController.didMove(toParent: self)
        }
    }
}
