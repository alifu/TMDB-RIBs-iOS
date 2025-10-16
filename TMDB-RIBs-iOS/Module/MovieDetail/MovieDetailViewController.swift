//
//  MovieDetailViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 06/10/25.
//

import Nuke
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import UIKit

protocol MovieDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func goBack()
    func didClickSaveButton()
}

final class MovieDetailViewController: UIViewController, MovieDetailPresentable, MovieDetailViewControllable {
    
    weak var listener: MovieDetailPresentableListener?
    private let disposeBag = DisposeBag()
    private var currentTaskPoster: ImageTask?
    private var currentTaskBackDrop: ImageTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.primary
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private let headerView: HeaderBar = {
        let view = HeaderBar()
        view.backgroundColor = .clear
        view.setupContent(titleText: "Detail", leftImage: UIImage(named: "arrow-left"))
        return view
    }()
    
    private let carouselContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .white
        view.numberOfLines = 2
        return view
    }()
    
    private let miniTabContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let overviewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let dividerOne: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.mediumDarkBlue
        return view
    }()
    
    private let dividerTwo: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.mediumDarkBlue
        return view
    }()
    
    private let genreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ticket")
        return imageView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let releaseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "calendar")
        return imageView
    }()
    
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let runtimeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "clock")
        return imageView
    }()
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let movieInfoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private func setupUI() {
        [
            headerView,
            carouselContainer,
            posterImageView,
            titleLabel,
            overviewContainer,
            miniTabContainer,
            movieInfoContainer
        ].forEach { item in
            self.view.addSubview(item)
        }
        [
            releaseImageView,
            releaseLabel,
            dividerOne,
            runtimeImageView,
            runtimeLabel,
            dividerTwo,
            genreImageView,
            genreLabel
        ].forEach { item in
            overviewContainer.addSubview(item)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        let heightOfBackDrop: CGFloat = RatioUtils.aspectRatioOFBackDrop(withWidth: UIScreen.safeWidth)
        carouselContainer.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(heightOfBackDrop)
        }
        
        let heightOfPoster: CGFloat = RatioUtils.aspectRatioOfPoster(withWidth: 100)
        posterImageView.snp.makeConstraints {
            $0.height.equalTo(heightOfPoster)
            $0.width.equalTo(100)
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalTo(carouselContainer.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(posterImageView.snp.centerY).offset(heightOfPoster / 4)
        }
        
        overviewContainer.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(12)
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.height.greaterThanOrEqualTo(0)
        }
        
        releaseImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.leading.equalTo(overviewContainer.snp.leading)
            $0.top.equalTo(overviewContainer.snp.top).offset(8)
            $0.bottom.equalTo(overviewContainer.snp.bottom).offset(-8)
        }
        
        releaseLabel.snp.makeConstraints {
            $0.top.equalTo(overviewContainer.snp.top).offset(8)
            $0.bottom.equalTo(overviewContainer.snp.bottom).offset(-8)
            $0.leading.equalTo(releaseImageView.snp.trailing).offset(4)
            $0.width.greaterThanOrEqualTo(0).priority(.required)
        }
        
        dividerOne.snp.makeConstraints {
            $0.top.equalTo(overviewContainer.snp.top).offset(8)
            $0.bottom.equalTo(overviewContainer.snp.bottom).offset(-8)
            $0.leading.equalTo(releaseLabel.snp.trailing).offset(4)
            $0.width.equalTo(1)
        }
        
        runtimeImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.leading.equalTo(dividerOne.snp.leading).offset(4)
            $0.top.equalTo(overviewContainer.snp.top).offset(8)
            $0.bottom.equalTo(overviewContainer.snp.bottom).offset(-8)
        }
        
        runtimeLabel.snp.makeConstraints {
            $0.top.equalTo(overviewContainer.snp.top).offset(8)
            $0.bottom.equalTo(overviewContainer.snp.bottom).offset(-8)
            $0.leading.equalTo(runtimeImageView.snp.trailing).offset(4)
            $0.width.greaterThanOrEqualTo(0).priority(.required)
        }
        
        dividerTwo.snp.makeConstraints {
            $0.top.equalTo(overviewContainer.snp.top).offset(8)
            $0.bottom.equalTo(overviewContainer.snp.bottom).offset(-8)
            $0.leading.equalTo(runtimeLabel.snp.trailing).offset(4)
            $0.width.equalTo(1)
        }
        
        genreImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.leading.equalTo(dividerTwo.snp.leading).offset(4)
            $0.top.equalTo(overviewContainer.snp.top).offset(8)
            $0.bottom.equalTo(overviewContainer.snp.bottom).offset(-8)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(overviewContainer.snp.top).offset(8)
            $0.bottom.equalTo(overviewContainer.snp.bottom).offset(-8)
            $0.leading.equalTo(genreImageView.snp.trailing).offset(4)
            $0.width.greaterThanOrEqualTo(0).priority(.required)
            $0.trailing.equalTo(overviewContainer.snp.trailing)
        }
        
        miniTabContainer.snp.makeConstraints {
            $0.top.equalTo(overviewContainer.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(41)
        }
        
        movieInfoContainer.snp.makeConstraints {
            $0.top.equalTo(miniTabContainer.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        headerView.leftTap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.navigationController?.popViewController(animated: true)
                self.listener?.goBack()
            })
            .disposed(by: disposeBag)
        
        headerView.rightTap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.listener?.didClickSaveButton()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadImages(with data: Event<TheMovieDetail.Response>) {        
        currentTaskPoster?.cancel()
        if let urlString = data.element?.posterPath, let url = URL(string: "\(Natrium.Config.baseImageW500Url)\(urlString)") {
            let request = ImageRequest(url: url)
            posterImageView.image = nil
            currentTaskPoster = ImagePipeline.shared.loadImage(with: request) { [weak self] result in
                guard let self else { return }
                switch result {
                case let .success(response):
                    UIView.transition(
                        with: self.posterImageView,
                        duration: 0.25,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.posterImageView.image = response.image
                        }
                    )
                case .failure(_):
                    self.posterImageView.image = nil
                }
            }
        }
    }
    
    func bindContent(with detail: Observable<TheMovieDetail.Response?>) {
        detail
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] data in
                guard let `self` = self else { return }
                self.loadImages(with: data)
                
                self.titleLabel.text = data.element?.title
                self.releaseLabel.text = data.element?.releaseYear
                let genres = data.element?.genres.map(\.name) ?? []
                self.genreLabel.text = genres.joined(separator: ", ")
                self.runtimeLabel.text = "\(data.element?.runtime ?? 0) Minutes"
            }
            .disposed(by: disposeBag)
    }
    
    func bindWatchListButton(with: Observable<Bool>) {
        with
            .subscribe(onNext: { [weak self] isWatchList in
                guard let `self` = self else { return }
                let image = isWatchList ? "saved" : "save"
                self.headerView.updateRightButton(
                    rightImage: UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
                )
            })
            .disposed(by: disposeBag)
    }
}

extension MovieDetailViewController {
    
    func loading(_ isLoading: Observable<Bool>) {
        isLoading
            .bind(to: self.view.rx.loaderVisible)
            .disposed(by: disposeBag)
    }
    
    func attachMovieDetailInfo(viewController: ViewControllable?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            movieInfoContainer.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.uiviewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.uiviewController.didMove(toParent: self)
        }
    }
    
    func attachCarousel(viewController: ViewControllable?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            carouselContainer.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.uiviewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.uiviewController.didMove(toParent: self)
        }
    }
    
    func attachWebPlayer(viewController: ViewControllable?) {
        if let target = viewController?.uiviewController {
            target.modalPresentationStyle = .fullScreen
            self.present(target, animated: true)
        }
    }
    
    func attachMiniTabView(viewController: ViewControllable?) {
        if let viewController {
            self.addChild(viewController.uiviewController)
            miniTabContainer.addSubview(viewController.uiviewController.view)
            viewController.uiviewController.view.translatesAutoresizingMaskIntoConstraints = false
            viewController.uiviewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.uiviewController.didMove(toParent: self)
        }
    }
}
