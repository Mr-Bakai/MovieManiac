//
//  ExploreViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 29/12/21.
//

import Foundation
import UIKit

enum ExploreSectionType{
    case popularPeople(viewModels: [PopularPeopleExploreCellViewModel])
    case featuredNetworks
    
    var title: String{
        switch self {
        case .popularPeople:
            return "Popular People"
        case .featuredNetworks:
            return "Featured Network"
        }
    }
}

class ExploreViewController: UIViewController {
    private let alamofire = AlamofireManager()
    private var sections = [ExploreSectionType]()
    private let collectionView: UICollectionView =
        UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ ->
            NSCollectionLayoutSection? in
            return ExploreViewController.createSectionLayoutForExploreVC(section: sectionIndex)
        })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupHierarchy()
        request()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - SetUpCollectionView
    private func setupCollectionView(){
        collectionView.register(
            PopularPeopleExploreCollectionViewCell.self,
            forCellWithReuseIdentifier: PopularPeopleExploreCollectionViewCell.identifier)
        
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupHierarchy(){
        view.addSubview(collectionView)
    }
    
    
    private func request(){
        var popularPeopleExploreResponse: PopularPeopleExploreResponse?
        
        alamofire.getPopularPeopleExplore(endPoint: .popularPeople, completion: { response in
            switch response {
            case .success(let model):
                popularPeopleExploreResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            guard let popularPeople = popularPeopleExploreResponse?.results else { return }
            self.configurePopularPeopleModel(with: popularPeople)
        })
    }
    
    
    //MARK: -ConfigureModels
    private func configurePopularPeopleModel(with popularPeople: [PopularPeopleExplore]){
        self.sections.append(.popularPeople(viewModels: popularPeople.compactMap({
            return PopularPeopleExploreCellViewModel(
                adult: $0.adult,
                gender: $0.gender,
                id: $0.id,
                knownFor: $0.knownFor,
                knownForDepartment: $0.knownForDepartment,
                name: $0.name,
                popularity: $0.popularity,
                profilePath: $0.profilePath)
        })))
        self.collectionView.reloadData()
    }
}

// MARK: -CollectionView
extension ExploreViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let model = sections[section]
        
        switch model {
        case .popularPeople(let viewModels):
            return viewModels.count
        case .featuredNetworks:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type {
        case .popularPeople(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularPeopleExploreCollectionViewCell.identifier, for: indexPath) as? PopularPeopleExploreCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .featuredNetworks:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
}

// MARK: - COMPOSITIONAL LAYOUT
extension ExploreViewController {
    static func createSectionLayoutForExploreVC(section: Int) -> NSCollectionLayoutSection{
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
                    widthDimension: .fractionalWidth(1.4),
                    heightDimension: .absolute(250)
                ),
                subitem: verticalGroup,
                count: 3
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
                    widthDimension: .fractionalWidth(1.4),
                    heightDimension: .absolute(250)
                ),
                subitem: verticalGroup,
                count: 3
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 3:
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
                    widthDimension: .fractionalWidth(1.4),
                    heightDimension: .absolute(250)
                ),
                subitem: verticalGroup,
                count: 3
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
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
