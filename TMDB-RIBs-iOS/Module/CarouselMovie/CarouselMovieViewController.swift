//
//  CarouselMovieViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 14/10/25.
//

import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

protocol CarouselMoviePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didSelectVideo(url: URL)
}

final class CarouselMovieViewController: UIViewController, CarouselMoviePresentable, CarouselMovieViewControllable {

    weak var listener: CarouselMoviePresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        setupUI()
    }
    
    func bindCarousel(_ movies: Observable<[TheMovieCaraousel]>) {
        movies
            .map { [SectionOfMovieCarousel(header: "featured", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfMovieCarousel>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCarouselCell.idView(), for: indexPath) as? MovieCarouselCell {
                cell.configure(with: item)
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
        collectionView.register(MovieCarouselCell.self, forCellWithReuseIdentifier: MovieCarouselCell.idView())
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
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
            collectionView.rx.modelSelected(TheMovieCaraousel.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, selected in
            guard let `self` = self else { return }
            if case .video(let video) = selected, let url = video.videoURL {
                self.listener?.didSelectVideo(url: url)
            }
        })
        .disposed(by: disposeBag)
    }
}

extension CarouselMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
