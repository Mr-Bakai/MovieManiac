//
//  ViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 29/12/21.

import UIKit

enum MoviesSectionType {
    case topRated(viewModels: [TopRatedMoviesCellViewModel])
    case popular(viewModels: [PopularMoviesCellViewModel])
    case upcoming(viewModels: [UpcomingMoviesCellViewModel])
    case nowPlaying(viewModels: [NowPlayingMoviesCellViewModel])
    
    var title: String {
        switch self{
        case .topRated:
            return "Top Rated"
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .nowPlaying:
            return "Now Playing"
        }
    }
}

class MoviesViewController: UIViewController {
    
    private let alamofire = AlamofireManager()
    private var sections = [MoviesSectionType]()
    
    lazy var leftBarButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                             style: .plain,
                                             target: self,
                                             action: nil)
    
    lazy var rightBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(menuTapped))
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout {
            sectionIndex, _ -> NSCollectionLayoutSection? in
            return MoviesViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupHierarchy()
        requests()
        setupLayout()
    }
    
    private func setupView(){
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.leftBarButtonItem?.tintColor = .gray
        
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .gray
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - SetUpCollectionView
    private func setupCollectionView(){
        collectionView.register(PopularMoviesCollectionViewCell.self,
                                forCellWithReuseIdentifier: PopularMoviesCollectionViewCell.identifier)
     
        collectionView.register(TopRatedMoviesCollectionViewCell.self,
                                forCellWithReuseIdentifier: TopRatedMoviesCollectionViewCell.identifier)
        
        collectionView.register(UpcomingCollectionViewCell.self, forCellWithReuseIdentifier: UpcomingCollectionViewCell.identifier)
        
        collectionView.register(NowPlayingMoviesCollectionViewCell.self, forCellWithReuseIdentifier: NowPlayingMoviesCollectionViewCell.identifier)
        
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupHierarchy(){
        view.addSubview(collectionView)
    }
    
    // MARK: - Requests
    private func requests(){
        
        var topRatedMoviesResponse: TopRatedMoviesResponse?
        var popularMoviesResponse: PopularMoviesResponse?
        var upcomingMoviesResponse: UpcomingMoviesResponse?
        var nowPlayingMoviesResponse: NowPlayingMoviesResponse?
      
        alamofire.getTopRatedMovies(endPoint: .topRated, completion: { response in
            switch response {
            case .success(let model):
                topRatedMoviesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            guard let topRatedMovies = topRatedMoviesResponse?.results else { return }
            self.configureTopRatedMoviesModel(topRatedMovies: topRatedMovies)
        })
        
        
        alamofire.getPopular(endPoint: .popular, completion: { response in
            switch response {
            case .success(let model):
                popularMoviesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            guard let popularMovies = popularMoviesResponse?.results else { return }
            self.configurePopularMoviesModel(popularMovies: popularMovies)
        })
        
        alamofire.getUpcoming(endPoint: .upcoming, completion: { response in
            switch response {
            case .success(let model):
                upcomingMoviesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            guard let upcomingMovies = upcomingMoviesResponse?.upcomingMovies else { return }
            self.configureUpcomingMoviesModel(upcomingMovies: upcomingMovies)
        })
        
        alamofire.getNowPlaying(endPoint: .nowPlaying, completion: { response in
            switch response {
            case .success(let model):
                nowPlayingMoviesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            guard let nowPlayingMovies = nowPlayingMoviesResponse?.nowPlayingMovies else { return }
            self.configureNowPlayingMoviesModel(nowPlayingMovies: nowPlayingMovies)
        })
    }
    
    
    // MARK: - ConfigureModels
    private func configureTopRatedMoviesModel(topRatedMovies: [TopRatedMovies]){
            self.sections.append(.topRated(viewModels: topRatedMovies.compactMap({
                return TopRatedMoviesCellViewModel(
                    backdropPath: $0.posterPath,
                    id: $0.id,
                    overview: $0.overview,
                    popularity: $0.popularity,
                    voteAverage: $0.voteAverage,
                    voteCount: $0.voteCount)
            })))
            self.collectionView.reloadData()
    }
    
    private func configurePopularMoviesModel(popularMovies: [PopularMovies]){
        sections.append(.popular(viewModels: popularMovies.compactMap({
            return PopularMoviesCellViewModel(
                backdropPath: $0.posterPath ?? "",
                id: $0.id,
                title: $0.title ?? "",
                popularity: $0.popularity,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount)
        })))
        collectionView.reloadData()
    }
    
    private func configureUpcomingMoviesModel(upcomingMovies: [UpcomingMovies]){
        self.sections.append(.upcoming(viewModels: upcomingMovies.compactMap({
            return UpcomingMoviesCellViewModel(
                backdropPath: $0.posterPath ?? "",
                id: $0.id,
                overview: $0.overview,
                posterPath: $0.posterPath,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount)
        })))
        self.collectionView.reloadData()
    }
    
    private func configureNowPlayingMoviesModel(nowPlayingMovies: [NowPlayingMovie]){
        self.sections.append(.nowPlaying(viewModels: nowPlayingMovies.compactMap({
            return NowPlayingMoviesCellViewModel(
                backdropPath: $0.posterPath,
                id: $0.id,
                overview: $0.overview,
                posterPath: $0.posterPath,
                title: $0.title,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount
            )
        })))
        self.collectionView.reloadData()
    }
    
    private func setupLayout(){
        collectionView.frame = view.bounds
    }
    
    @objc private func menuTapped(){
        print("Does it? ")
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CollectionView
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let model = sections[section]
        
        // Why Should i switch them
        switch model {
        case .topRated(let viewModels):
            return viewModels.count
        case .popular(let viewModels):
            return viewModels.count
        case .upcoming(let viewModels):
            return viewModels.count
        case .nowPlaying(let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
   //  IndexPath {
   //        let section: 0
   //        let row: 4
   //    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        
        switch type {
        
        case .topRated(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRatedMoviesCollectionViewCell.identifier, for: indexPath) as? TopRatedMoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .popular(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMoviesCollectionViewCell.identifier, for: indexPath) as? PopularMoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .upcoming(let viewModels):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingCollectionViewCell.identifier, for: indexPath) as? UpcomingCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .nowPlaying(let viewModels):
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingMoviesCollectionViewCell.identifier, for: indexPath) as? NowPlayingMoviesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
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
extension MoviesViewController {
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
