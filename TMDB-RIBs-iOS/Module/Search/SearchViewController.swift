//
//  SearchViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif Phincon on 30/09/25.
//

import RIBs
import RxSwift
import UIKit

protocol SearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        self.view.backgroundColor = ColorUtils.primary

        // Configure search controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        // Optional: handle search text changes
        searchController.searchResultsUpdater = self
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        print("User is searching: \(query)")
    }
}
