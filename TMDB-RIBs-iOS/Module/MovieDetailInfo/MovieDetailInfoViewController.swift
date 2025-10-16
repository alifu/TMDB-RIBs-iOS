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
}

final class MovieDetailInfoViewController: UIViewController, MovieDetailInfoPresentable, MovieDetailInfoViewControllable {

    weak var listener: MovieDetailInfoPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupUI()
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
    
    func errorViewVisible(_ model: Observable<ErrorViewModel?>) {
        model
            .bind(to: self.view.rx.errorView)
            .disposed(by: disposeBag)
    }
    
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
        self.view.addSubview(overviewLabel)
        self.view.addSubview(reviewTableView)
        self.view.addSubview(creditCollectionView)
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        creditCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        reviewTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        creditCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension MovieDetailInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == creditCollectionView {
            let width = (collectionView.bounds.width - 60) / 2
            return CGSize(width: width, height: width + 24)
        }
        return .zero
    }
}

extension MovieDetailInfoViewController {
    
    func loading(_ isLoading: Observable<Bool>) {
        isLoading
            .bind(to: self.view.rx.loaderVisible)
            .disposed(by: disposeBag)
    }
}
