//
//  SearchResultViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 25/5/22.
//
import Foundation
import UIKit

struct SearchSection{
    let title: String
    let results: [SearchMultiResult]
}

final class SearchResultViewController: UIViewController {
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ ->
        NSCollectionLayoutSection? in
        return SearchResultViewController.createSectionLayout(section: sectionIndex)
    })
    
    private var sections: [SearchSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    func configureCollectionView(){
        view.addSubview(collectionView)
        
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        
        collectionView.register(TVSeriesCollectionViewCell.self, forCellWithReuseIdentifier: TVSeriesCollectionViewCell.identifier)
        
        collectionView.register(PeopleCollectionViewCell.self, forCellWithReuseIdentifier: PeopleCollectionViewCell.identifier)
        
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func update(with results: [SearchMultiResult]){
        
        let movies = results.filter({
            switch $0{
            case .movie: return true
            default: return false
            }
        })
        
        let tv = results.filter({
            switch $0 {
            case .tv: return true
            default: return false
            }
        })
        
        let person = results.filter({
            switch $0 {
            case .person: return true
            default: return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Movie", results: movies),
            SearchSection(title: "Tv", results: tv),
            SearchSection(title: "Person", results: person),
        ]
        collectionView.reloadData()
    }
}


// MARK: Extensions
extension SearchResultViewController: UICollectionViewDelegate,
                                      UICollectionViewDataSource{
    // MARK: CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].results[indexPath.row]
        
        switch model {
        case .movie(let movie):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = MovieCellViewModel(
                backdropPath: movie.posterPath,
                id: movie.id,
                title: movie.title ?? "",
                popularity: movie.popularity ?? 0.0,
                voteAverage: movie.voteAverage ?? 0.0,
                voteCount: movie.voteCount ?? 0
            )
            cell.configure(with: viewModel)
            return cell
            
        case .tv(let tvShows):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVSeriesCollectionViewCell.identifier, for: indexPath) as? TVSeriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            // TODO THIS
            let viewModel = TVSeriesCellViewModel(
                backdropPath: tvShows.posterPath,
                id: tvShows.id,
                title: tvShows.title ?? "",
                popularity: tvShows.popularity ?? 0.0,
                voteAverage: tvShows.voteAverage ?? 0.0,
                voteCount: tvShows.voteCount ?? 0
            )
            print("=================================")
            print("=================================")
            print(viewModel.backdropPath ?? "")
            cell.configure(with: viewModel)
            return cell
            
        case .person(let people):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PeopleCollectionViewCell.identifier, for: indexPath) as? PeopleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = PeopleCellViewModel(
                profilePath: people.profilePath,
                backdropPath: people.backdropPath,
                id: people.id,
                name: people.name ?? "",
                title: people.title ?? "",
                popularity: people.popularity ?? 0.0,
                voteAverage: people.voteAverage ?? 0.0,
                voteCount: people.voteCount ?? 0
            )
            cell.configure(with: viewModel)
            return cell
        }
    }
 
    // TODO: Remove Sections if empty
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        
       let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)),
                
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        switch section {
        case 0:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4,leading: 2,bottom: 4,trailing: 2)
            
            // Vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1)
                ),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(250)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 1:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4,leading: 2,bottom: 4,trailing: 2)
            
            // Vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1)
                ),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(250)
                ),
                subitem: verticalGroup,
                count: 1
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 2:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4,leading: 2,bottom: 4,trailing: 2)
            
            // Vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                ),
                subitem: item,
                count: 1
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(270)
                ),
                subitem: verticalGroup,
                count: 4
            )
            horizontalGroup.interItemSpacing = .fixed(10)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            section.interGroupSpacing = 10
            return section
            
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,leading: 2,bottom: 2,trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}
