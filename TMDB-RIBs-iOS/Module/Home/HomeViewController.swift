//
//  HomeViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa
import RxGesture
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
    var didLoadMoreTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.primary
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Private
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
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
    
    private let movieListContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private func setupUI() {
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        let headView = UIView()
        headView.addSubview(headerTitleLabel)
        headView.addSubview(searchBox)
        
        contentStack.addArrangedSubview(headView)
        headView.snp.makeConstraints { $0.height.greaterThanOrEqualTo(10) }
        
        contentStack.addArrangedSubview(popularMoviewContainer)
        contentStack.addArrangedSubview(movieListContainer)
        
        headerTitleLabel.snp.makeConstraints {
            $0.top.equalTo(headView.snp.top)
            $0.leading.equalTo(headView.snp.leading).offset(16)
            $0.trailing.equalTo(headView.snp.trailing).offset(-16)
            $0.height.greaterThanOrEqualTo(10)
        }
        
        searchBox.snp.makeConstraints {
            $0.top.equalTo(headerTitleLabel.snp.bottom).offset(24)
            $0.leading.equalTo(headView.snp.leading).offset(16)
            $0.trailing.equalTo(headView.snp.trailing).offset(-16)
            $0.height.equalTo(42)
            $0.bottom.equalTo(headView.snp.bottom)
        }
        
        popularMoviewContainer.snp.makeConstraints { $0.height.equalTo(250) }
        
        movieListContainer.snp.makeConstraints { $0.height.greaterThanOrEqualTo(200) }
        
        searchBox.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                if #available(iOS 26.0, *) {
                    self.tabBarController?.selectedIndex = 2
                } else {
                    self.tabBarController?.selectedIndex = 1
                }
            })
            .disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .map { [weak self] offset -> Bool in
                guard let self = self else { return false }
                let visibleHeight = self.scrollView.frame.height
                let y = offset.y + visibleHeight
                let threshold = self.scrollView.contentSize.height - 200
                return y > threshold
            }
            .distinctUntilChanged()
            .filter { $0 } // only when crossing threshold
            .map { _ in () }
            .bind(to: didLoadMoreTrigger)
            .disposed(by: disposeBag)
    }
    
    func updateHeightMovieList(with height: Observable<CGFloat>) {
        height
            .subscribe(onNext: { [weak self] height in
                guard let `self` = self else { return }
                self.movieListContainer.snp.updateConstraints {
                    $0.height.greaterThanOrEqualTo(height)
                }
                UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    
    func attachFeaturedMovieView(viewController: ViewControllable?) {
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
    
    func attachMovieListsView(viewController: ViewControllable?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            movieListContainer.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.uiviewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.uiviewController.didMove(toParent: self)
        }
    }
    
    func openMovieDetail(viewController: (any ViewControllable)?) {
        if let viewController {
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController.uiviewController, animated: true)
        }
    }
}
