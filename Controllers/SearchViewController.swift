//
//  SearchViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 8/1/22.


import UIKit

final class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    let searchController: UISearchController = {
       let results = UIViewController()
        results.view.backgroundColor = .gray
        let vc = UISearchController(searchResultsController: results)
        vc.searchBar.placeholder = "Movies, Series, Cartoons"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        print(query)
    }
}
