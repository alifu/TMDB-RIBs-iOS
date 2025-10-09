//
//  WatchListViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
//

import RIBs
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import UIKit

protocol WatchListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didSelectMovie(_ movie: TheMovieWatchList.Result)
}

final class WatchListViewController: UIViewController, WatchListPresentable, WatchListViewControllable {
    
    weak var listener: WatchListPresentableListener?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.primary
        self.navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func bindMovieItems(_ items: Observable<[TheMovieWatchList.Result]>) {
        items
            .map { [SectionOfWatchListMovie(header: "movie", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionOfWatchListMovie>(
        configureCell: { _, tableView, indexPath, item in
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCardCell.idView(), for: indexPath) as? MovieCardCell {
                cell.setupContent(with: item)
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        }
    )
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieCardCell.self, forCellReuseIdentifier: MovieCardCell.idView())
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let headerView: HeaderBar = {
        let view = HeaderBar()
        view.backgroundColor = .clear
        view.setupContent(titleText: "Watch List")
        return view
    }()
    
    private func setupUI() {
        self.view.addSubview(headerView)
        self.view.addSubview(tableView)
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(TheMovieWatchList.Result.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, selected in
            guard let `self` = self else { return }
            self.listener?.didSelectMovie(selected)
        })
        .disposed(by: disposeBag)
    }
}

extension WatchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
}

extension WatchListViewController {
    
    func openMovieDetail(viewController: (any ViewControllable)?) {
        if let viewController {
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController.uiviewController, animated: true)
        }
    }
}
