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
    func didSelectMovieList(_ indexPath: IndexPath, item: TheMovieLists.Tab)
    func didSelectMovie(_ indexPath: IndexPath, item: TheMovieLists.Wrapper)
}

final class MovieListsViewController: UIViewController, MovieListsPresentable, MovieListsViewControllable {

    weak var listener: MovieListsPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupUI()
    }
    
    func bindMovieLists(_ data: Observable<[TheMovieLists.Tab]>) {
        data
            .map { [SectionOfMovieLists(header: "lists", items: $0)] }
            .bind(to: tabCollectionView.rx.items(dataSource: tabDataSource))
            .disposed(by: disposeBag)
    }
    
    func bindMovies(_ data: Observable<[TheMovieLists.Wrapper]>) {
        data
            .map { [SectionOfMovies(header: "movie", items: $0)] }
            .bind(to: movieCollectionView.rx.items(dataSource: moviesDataSource))
            .disposed(by: disposeBag)
    }
    
    private let tabDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMovieLists>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MiniTabCell.idView(), for: indexPath) as? MiniTabCell {
                cell.setupContent(item)
                return cell
            }
            return UICollectionViewCell()
        }
    )
    
    private let moviesDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMovies>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListsCardCell.idView(), for: indexPath) as? MovieListsCardCell {
                cell.setupContent(item: item)
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
    
    private let movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieListsCardCell.self, forCellWithReuseIdentifier: MovieListsCardCell.idView())
        collectionView.backgroundColor = .clear
        collectionView.contentInset.left = 16
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private func setupUI() {
        self.view.addSubview(tabCollectionView)
        self.view.addSubview(movieCollectionView)
        
        tabCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(41)
        }
        
        movieCollectionView.snp.makeConstraints {
            $0.top.equalTo(tabCollectionView.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        tabCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        movieCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.zip(
            tabCollectionView.rx.itemSelected,
            tabCollectionView.rx.modelSelected(TheMovieLists.Tab.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, item in
            guard let `self` = self else { return }
            self.listener?.didSelectMovieList(indexPath, item: item)
        })
        .disposed(by: disposeBag)
        
        Observable.zip(
            movieCollectionView.rx.itemSelected,
            movieCollectionView.rx.modelSelected(TheMovieLists.Wrapper.self)
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
        if collectionView == tabCollectionView {
            let width = 92
            return CGSize(width: width, height: 41)
        } else if collectionView == movieCollectionView {
            let width = (collectionView.bounds.width - 48) / 3
            let height = RatioUtils.aspectRatioOfPoster(withWidth: width)
            return CGSize(width: width, height: height)
        }
        return .zero
    }
}
