//
//  SearchViewController.swift
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

extension UISearchBar {
    func setInputColor(_ color: UIColor) {
        let textField = self.value(forKey: "searchField") as? UITextField
        textField?.textColor = color
    }
}

protocol SearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didSearch(with query: String)
    func didSelectMovie(_ movie: TheMovieSearchMovie.Result)
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
    
    weak var listener: SearchPresentableListener?
    private let searchController = UISearchController(searchResultsController: nil)
    private var pendingRequestWorkItem: DispatchWorkItem?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorUtils.primary
        
        // Configure search controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies..."
        searchController.searchBar.searchTextField.textColor = .green
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Optional: handle search text changes
        searchController.searchResultsUpdater = self
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 26.0, *) {
            self.navigationController?.navigationBar.isHidden = true
        } else {
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.title = "Search"
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
            
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func bindMovieItems(_ items: Observable<[TheMovieSearchMovie.Result]>) {
        items
            .map { [SectionOfSearchMovie(header: "movie", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionOfSearchMovie>(
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
        view.setupContent(titleText: "Search")
        return view
    }()
    
    private func setupUI() {
        if #available(iOS 26.0, *) {
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
        } else {
            self.view.addSubview(tableView)
            
            tableView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(TheMovieSearchMovie.Result.self)
        )
        .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] indexPath, selected in
            guard let `self` = self else { return }
            self.listener?.didSelectMovie(selected)
        })
        .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        
        // Cancel the last pending item
        pendingRequestWorkItem?.cancel()
        
        // Wrap the new task in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: query)
        }
        
        // Save the new work item and execute after 1000ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: requestWorkItem)
    }
    
    private func performSearch(query: String) {
        if query.isEmpty {
            print("Clear results")
        } else {
            print("Search for: \(query)")
            self.listener?.didSearch(with: query)
        }
    }
}

extension SearchViewController {
    
    func openMovieDetail(viewController: (any ViewControllable)?) {
        if let viewController {
            self.navigationController?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController.uiviewController, animated: true)
        }
    }
    
    func errorViewVisible(_ model: Observable<ErrorViewModel?>) {
        model
            .bind(to: self.view.rx.errorView)
            .disposed(by: disposeBag)
    }
    
    func loading(_ isLoading: Observable<Bool>) {
        isLoading
            .bind(to: self.view.rx.loaderVisible)
            .disposed(by: disposeBag)
    }
}
