//
//  MovieListsViewController.swift
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

protocol MovieListsPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didSelectMovie(_ indexPath: IndexPath, item: TheMovieLists.Wrapper)
    func didUpdateHeight(with height: CGFloat)
}

final class MovieListsViewController: UIViewController, MovieListsPresentable, MovieListsViewControllable {

    weak var listener: MovieListsPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupUI()
    }
    
    func bindMovies(_ data: Observable<[TheMovieLists.Wrapper]>) {
        data
            .map { [SectionOfMovies(header: "movie", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfMovies>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListsCardCell.idView(), for: indexPath) as? MovieListsCardCell {
                cell.setupContent(item: item)
                return cell
            }
            return UICollectionViewCell()
        }
    )
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieListsCardCell.self, forCellWithReuseIdentifier: MovieListsCardCell.idView())
        collectionView.backgroundColor = .clear
        collectionView.contentInset.left = 16
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private func setupUI() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .observe(CGSize.self, "contentSize")
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] size in
                guard let `self` = self else { return }
                self.listener?.didUpdateHeight(with: size.height + 53)
            })
            .disposed(by: disposeBag)
        
        Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(TheMovieLists.Wrapper.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, selected in
            guard let `self` = self else { return }
            self.listener?.didSelectMovie(indexPath, item: selected)
        })
        .disposed(by: disposeBag)
    }
}

extension MovieListsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 3
        let height = RatioUtils.aspectRatioOfPoster(withWidth: width)
        return CGSize(width: width, height: height)
    }
}

extension MovieListsViewController {
    
    func loading(_ isLoading: Observable<Bool>) {
        isLoading
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] loading in
                guard let `self` = self else { return }
                self.collectionView.isHidden = loading
            })
            .bind(to: self.view.rx.loaderVisible)
            .disposed(by: disposeBag)
    }
}
