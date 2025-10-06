//
//  PopularMovieViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 02/10/25.
//

import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

protocol PopularMoviePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class PopularMovieViewController: UIViewController, PopularMoviePresentable, PopularMovieViewControllable {
    
    weak var listener: PopularMoviePresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        setupUI()
    }
    
    func bindPopularMovie(_ movies: Observable<[TheMoviePopular.Result]>) {
        movies
            .map { [SectionOfPopularMovie(header: "popular", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfPopularMovie>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCell.idView(), for: indexPath) as? PopularMovieCell {
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
        collectionView.register(PopularMovieCell.self, forCellWithReuseIdentifier: PopularMovieCell.idView())
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
    }
}

extension PopularMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = RatioUtils.aspectRatioOfPoster(withHeight: 226) + 32
        return CGSize(width: width, height: 250)
    }
}
