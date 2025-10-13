//
//  FeaturedMovieViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 13/10/25.
//

import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

protocol FeaturedMoviePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didSelectedMovie(_ movie: TheMovieTrendingToday.Result)
}

final class FeaturedMovieViewController: UIViewController, FeaturedMoviePresentable, FeaturedMovieViewControllable {

    weak var listener: FeaturedMoviePresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        setupUI()
    }
    
    func bindFeaturedMovie(_ movies: Observable<[TheMovieTrendingToday.Result]>) {
        movies
            .map { [SectionOfTrendingTodayMovie(header: "featured", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfTrendingTodayMovie>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedMovieCell.idView(), for: indexPath) as? FeaturedMovieCell {
                cell.setupContent(indexPath: indexPath, item: item)
                return cell
            }
            return UICollectionViewCell()
        }
    )
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeaturedMovieCell.self, forCellWithReuseIdentifier: FeaturedMovieCell.idView())
        collectionView.backgroundColor = .clear
        collectionView.contentInset.left = 16
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private func setupUI() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(TheMovieTrendingToday.Result.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, selected in
            guard let `self` = self else { return }
            self.listener?.didSelectedMovie(selected)
        })
        .disposed(by: disposeBag)
    }
}

extension FeaturedMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = RatioUtils.aspectRatioOfPoster(withHeight: 226) + 32
        return CGSize(width: width, height: 250)
    }
}

extension FeaturedMovieViewController {
    
    func loading(_ isLoading: Observable<Bool>) {
        isLoading
            .bind(to: self.view.rx.loaderVisible)
            .disposed(by: disposeBag)
    }
}
