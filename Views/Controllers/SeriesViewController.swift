//
//  SeriesViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 29/12/21.
//
import UIKit

enum TVSeriesSectionType {
    case airingTodayTVSeries(viewModels: [AiringTodayTVSeriesCellViewModel])
    case popularTVSeries(viewModels: [PopularTVSeriesCellViewModel])
    case topRatedTVSeries(viewModels: [TopRatedTVSeriesCellViewModel])
    
    var title: String {
        switch self{
        case .airingTodayTVSeries:
            return "Airing Today"
        case .popularTVSeries:
            return "Popular Now"
        case .topRatedTVSeries:
            return "Top Rated"
        }
    }
}

class SeriesViewController: UIViewController {
    
    private let alamofire = AlamofireManager()
    private var sections = [TVSeriesSectionType]()
    private let collectionView: UICollectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ ->
        NSCollectionLayoutSection? in
        return SeriesViewController.createSectionLayoutForSeriesVC(section: sectionIndex)
    })
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupHierarchy()
        requests()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - SetUpCollectionView
    private func setupCollectionView(){
        collectionView.register(
            AiringTodayTVSeriesCollectionViewCell.self,
            forCellWithReuseIdentifier: AiringTodayTVSeriesCollectionViewCell.identifier)
        
        collectionView.register(
            PopularTVSeriesCollectionViewCell.self,
            forCellWithReuseIdentifier: PopularTVSeriesCollectionViewCell.identifier)
        
        collectionView.register(
            TopRatedTVSeriesCollectionViewCell.self,
            forCellWithReuseIdentifier: TopRatedTVSeriesCollectionViewCell.identifier)
        
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupHierarchy(){
        view.addSubview(collectionView)
    }
    
    
    private func requests(){
        var airingTodayTVSeriesResponse: AiringTodayTVSeriesResponse?
        var popularTVSeriesResponse: PopularTVSeriesResponse?
        var topRatedTVSeriesResponse: TopRatedTVSeriesResponse?
        
        alamofire.getAiringToday(endPoint: .airingTodayTVSeries, completion: { response in
            switch response {
            case .success(let model):
                airingTodayTVSeriesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            guard let airingTodayTVSeries = airingTodayTVSeriesResponse?.results else { return }
            self.configureAiringTodayTVSeriesModel(airingTodayTVSeries: airingTodayTVSeries)
        })
        
        
        alamofire.getPopularTVSeries(endPoint: .popularTVSeries, completion: { response in
            switch response {
            case .success(let model):
                popularTVSeriesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            guard let popularTVSeries = popularTVSeriesResponse?.results else { return }
            self.configurePopularTVSeriesModel(popularTVSeries: popularTVSeries)
        })
        
        alamofire.getTopRatedTVSeries(endPoint: .topRatedTVSeries, completion: { response in
            switch response {
            case .success(let model):
                topRatedTVSeriesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            guard let topRatedTVSeries = topRatedTVSeriesResponse?.results else { return }
            self.configureTopRatedTVSeries(topRatedTVSeries: topRatedTVSeries)
        })
    }
    
    
    // MARK: -ConfigureModels
    private func configureAiringTodayTVSeriesModel(airingTodayTVSeries: [AiringTodayTVSeries]){
        self.sections.append(.airingTodayTVSeries(viewModels: airingTodayTVSeries.compactMap({
            return AiringTodayTVSeriesCellViewModel(
                backdropPath: $0.posterPath,
                id: $0.id,
                overview: $0.overview,
                popularity: $0.popularity,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount)
        })))
        collectionView.reloadData()
    }
    
    private func configurePopularTVSeriesModel(popularTVSeries: [PopularTVSeries]){
        self.sections.append(.popularTVSeries(viewModels: popularTVSeries.compactMap({
            return PopularTVSeriesCellViewModel(
                backdropPath: $0.backdropPath,
                id: $0.id,
                overview: $0.overview,
                popularity: $0.popularity,
                posterPath: $0.posterPath ,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount)
        })))
        collectionView.reloadData()
    }
    
    private func configureTopRatedTVSeries(topRatedTVSeries: [TopRatedTVSeries]){
        self.sections.append(.topRatedTVSeries(viewModels: topRatedTVSeries.compactMap({
            return TopRatedTVSeriesCellViewModel(
                backdropPath: $0.backdropPath,
                id: $0.id,
                overview: $0.overview,
                popularity: $0.popularity,
                posterPath: $0.posterPath,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount)
        })))
        collectionView.reloadData()
    }
}

// MARK: -CollectionView
extension SeriesViewController: UICollectionViewDataSource,
                                UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        
        switch type {
        
        case .airingTodayTVSeries(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AiringTodayTVSeriesCollectionViewCell.identifier, for: indexPath) as? AiringTodayTVSeriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .popularTVSeries(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularTVSeriesCollectionViewCell.identifier, for: indexPath) as? PopularTVSeriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .topRatedTVSeries(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRatedTVSeriesCollectionViewCell.identifier, for: indexPath) as? TopRatedTVSeriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        let model = sections[section]
        
        switch model {
        case .airingTodayTVSeries(let viewModels):
            return viewModels.count
        case .popularTVSeries( let viewModels):
            return viewModels.count
        case .topRatedTVSeries(let viewModels):
            return viewModels.count
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
extension SeriesViewController {
    static func createSectionLayoutForSeriesVC(section: Int) -> NSCollectionLayoutSection{
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
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2,leading: 1,bottom: 2,trailing: 1)
            
            // Vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
                count: 1
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.75),
                    heightDimension: .absolute(390)
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
