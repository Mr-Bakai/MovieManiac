//
//  SearchViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 8/1/22.

import UIKit

final class SearchViewController: UIViewController,
                                  UISearchResultsUpdating,
                                  UISearchBarDelegate {
    private let alamofire = AlamofireManager()
    private var searchResult: [SearchMultiResult] = []
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.placeholder = "Movies, Series, Cartoons"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultController = searchController.searchResultsController as? SearchResultViewController,
        let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        // MultiSearchResponse is to be fixed
        alamofire.makeMultiSearch(searchFor: query,
                                  endPoint: .multiSearch) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.sortMultiSearchResponse(sort: model)
                    resultController.update(with: self.searchResult)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func sortMultiSearchResponse(sort response: SearchMultiResponse){
        
        guard let finalResult = response.results else {
            return
        }
        searchResult.removeAll()
        
        // BETTER: Better way of sorting things out in here
        for movie in finalResult {
            if movie.mediaType.rawValue == "movie"{
                searchResult.append(.movie(model: movie))
            }
        }
        
        for tvShow in finalResult {
            if tvShow.mediaType.rawValue == "tv"{
                searchResult.append(.movie(model: tvShow))
            }
        }
        
        for person in finalResult {
            if person.mediaType.rawValue == "person"{
                searchResult.append(.movie(model: person))
            }
        }
    }
}
