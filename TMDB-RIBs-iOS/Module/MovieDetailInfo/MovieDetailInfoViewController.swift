//
//  MovieDetailInfoViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 08/10/25.
//

import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

protocol MovieDetailInfoPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didSelectTab(_ indexPath: IndexPath, item: TheMovieDetailInfo.Tab)
}

final class MovieDetailInfoViewController: UIViewController, MovieDetailInfoPresentable, MovieDetailInfoViewControllable {

    weak var listener: MovieDetailInfoPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupUI()
    }
    
    func bindTab(_ data: Observable<[TheMovieDetailInfo.Tab]>) {
        data
            .map{ [SectionOfMovieDetailInfo(header: "tab", items: $0)] }
            .bind(to: tabCollectionView.rx.items(dataSource: tabDataSource))
            .disposed(by: disposeBag)
    }
    
    func bindSelectedTab(_ data: Observable<MovieDetailInfoType>) {
        data
            .map { $0 }
            .subscribe(onNext: { [weak self] tab in
                guard let `self` = self else { return }
                self.overviewLabel.isHidden = tab != .aboutMovie
                self.reviewTableView.isHidden = tab != .reviews
                self.creditCollectionView.isHidden = tab != .cast
            })
            .disposed(by: disposeBag)
    }
    
    func bindAboutMovie(_ data: Observable<String?>) {
        data
            .map { $0 }
            .bind(to: overviewLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindMovieReviews(_ data: Observable<[TheMovieReview.Result]>) {
        data
            .map { [SectionOfMovieReview(header: "review", items: $0)] }
            .bind(to: reviewTableView.rx.items(dataSource: reviewDataSource))
            .disposed(by: disposeBag)
    }
    
    func bindMovieCredits(_ data: Observable<[TheMovieCredit.Cast]>) {
        data
            .map { [SectionOfMovieCredit(header: "cast", items: $0)] }
            .bind(to: creditCollectionView.rx.items(dataSource: creditDataSource))
            .disposed(by: disposeBag)
    }
    
    private let tabDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMovieDetailInfo>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MiniTabCell.idView(), for: indexPath) as? MiniTabCell {
                cell.setupContent(item)
                return cell
            }
            return UICollectionViewCell()
        }
    )
    
    private let creditDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMovieCredit>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCreditCell.idView(), for: indexPath) as? MovieCreditCell {
                cell.setupContent(with: item, radius: (collectionView.bounds.width - 60) / 4)
                return cell
            }
            return UICollectionViewCell()
        }
    )
    
    private let reviewDataSource = RxTableViewSectionedReloadDataSource<SectionOfMovieReview>(
        configureCell: { _, tableView, indexPath, item in
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieReviewCell.idView(), for: indexPath) as? MovieReviewCell {
                cell.setupContent(with: item)
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        }
    )
    
    private let tabCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MiniTabCell.self, forCellWithReuseIdentifier: MiniTabCell.idView())
        collectionView.backgroundColor = .clear
        collectionView.contentInset.left = 16
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let reviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieReviewCell.self, forCellReuseIdentifier: MovieReviewCell.idView())
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let creditCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCreditCell.self, forCellWithReuseIdentifier: MovieCreditCell.idView())
        collectionView.backgroundColor = .clear
        collectionView.contentInset.left = 16
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private func setupUI() {
        self.view.addSubview(tabCollectionView)
        self.view.addSubview(overviewLabel)
        self.view.addSubview(reviewTableView)
        self.view.addSubview(creditCollectionView)
        
        tabCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(41)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        creditCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom).offset(16)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        reviewTableView.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom).offset(16)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        tabCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        creditCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.zip(
            tabCollectionView.rx.itemSelected,
            tabCollectionView.rx.modelSelected(TheMovieDetailInfo.Tab.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, item in
            guard let `self` = self else { return }
            self.listener?.didSelectTab(indexPath, item: item)
        })
        .disposed(by: disposeBag)
    }
}

extension MovieDetailInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCollectionView {
            let width = 92
            return CGSize(width: width, height: 41)
        } else if collectionView == creditCollectionView {
            let width = (collectionView.bounds.width - 60) / 2
            return CGSize(width: width, height: width + 24)
        }
        return .zero
    }
}
