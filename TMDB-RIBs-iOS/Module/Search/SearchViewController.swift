//
//  SearchViewController.swift
//  TMDB-RIBs-iOS
//
//  Created by Alif on 30/09/25.
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
    private var pendingRequestWorkItem: DispatchWorkItem?
    
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
        
        // Cancel the last pending item
        pendingRequestWorkItem?.cancel()
        
        // Wrap the new task in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: query)
        }
        
        // Save the new work item and execute after 300ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: requestWorkItem)
    }
    
    private func performSearch(query: String) {
        if query.isEmpty {
            print("Clear results")
        } else {
            print("Search for: \(query)")
        }
    }
}
