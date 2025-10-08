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
            })
            .disposed(by: disposeBag)
    }
    
    func bindAboutMovie(_ data: Observable<String?>) {
        data
            .map { $0 }
            .bind(to: overviewLabel.rx.text)
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
        
        tabCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(41)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        tabCollectionView.rx.setDelegate(self)
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
        }
        return .zero
    }
}
