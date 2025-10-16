//
//  MiniTabViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 15/10/25.
//

import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

protocol MiniTabPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didLoadTab()
    func didSelectTab(_ indexPath: IndexPath, item: MiniTab)
}

final class MiniTabViewController: UIViewController, MiniTabPresentable, MiniTabViewControllable {

    weak var listener: MiniTabPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listener?.didLoadTab()
    }
    
    func bindMiniTab(_ data: Observable<[MiniTab]>) {
        data
            .map { tabs in
                [SectionOfMiniTab(context: tabs.detectedContext, items: tabs)]
            }
            .bind(to: collectionView.rx.items(dataSource: tabDataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    
    private let tabDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMiniTab>(
        configureCell: { _, collectionView, indexPath, item in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MiniTabCell.idView(), for: indexPath) as? MiniTabCell {
                switch item {
                case .movieList(let data):
                    cell.setupContent(data)
                case .movieDetail(let data):
                    cell.setupContent(data)
                }
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
        collectionView.register(MiniTabCell.self, forCellWithReuseIdentifier: MiniTabCell.idView())
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
            collectionView.rx.modelSelected(MiniTab.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, item in
            guard let `self` = self else { return }
            self.listener?.didSelectTab(indexPath, item: item)
        })
        .disposed(by: disposeBag)
    }
}

extension MiniTabViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 92
        return CGSize(width: width, height: 41)
    }
}
