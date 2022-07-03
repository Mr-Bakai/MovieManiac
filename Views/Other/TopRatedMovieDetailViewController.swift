//
//  TopRatedMovieDetailViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 8/6/22.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

enum DetailedMovieSectionType {
    case overView(viewModel: DetailedMovieOverviewCellViewModel)
    case cast(viewModel: [TopRatedDetailedMovieCastCellViewModel])
    
    var title: String {
        switch self {
        case .overView: return "Overview"
        case .cast: return "Cast"
        }
    }
}

class TopRatedMovieDetailViewController: UIViewController {
    
    private var sections = [DetailedMovieSectionType]()
    
    private var topRatedMovie: TopRatedMovie
    private var detailedMovie: DetailedMovieResponse?
    
    private var imageBaseURL = AlamofireManager.imageBase
    private let alamofire = AlamofireManager()
    
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ ->
        NSCollectionLayoutSection? in
        return TopRatedMovieDetailViewController.createSectionLayout(section: sectionIndex)
    })
    
    init(movie: TopRatedMovie) {
        self.topRatedMovie = movie
        self.detailedMovie = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupHierarchy()
        setupCollectionView()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: FetchData
    private func fetchData(){
        
        var topRatedDetailedMovieCast: TopRatedDetailedMovieCastResponse?
            
        alamofire.getDetailedMovie(movieId: topRatedMovie.id,
                                   endPoint: .detailedMovie,
                                   completion: { response in
            switch response {
            case .success(let model):
                self.sections.append(.overView(viewModel: DetailedMovieOverviewCellViewModel(
                                                adult: model.adult,
                                                backdropPath: model.backdropPath,
                                                budget: model.budget,
                                                genres: model.genres,
                                                homepage: model.homepage,
                                                id: model.id,
                                                imdbID: model.imdbID,
                                                originalLanguage: model.originalLanguage,
                                                originalTitle: model.originalTitle,
                                                overview: model.overview,
                                                popularity: model.popularity,
                                                posterPath: model.posterPath,
                                                productionCompanies:model.productionCompanies,
                                                productionCountries:model.productionCountries,
                                                releaseDate: model.releaseDate,
                                                revenue: model.revenue,
                                                runtime: model.runtime,
                                                spokenLanguages: model.spokenLanguages,
                                                status: model.status,
                                                tagline: model.tagline,
                                                title: model.title,
                                                video: model.video,
                                                voteAverage: model.voteAverage,
                                                voteCount: model.voteCount)))
                
                self.alamofire.getTopRatedDetailedMovieCast(movieId: model.id,
                                                            endPoint: .topRatedDetailedMovieCast,
                                                            completion: { response in
                    switch response {
                    case .success(let model):
                        
                        topRatedDetailedMovieCast = model
                        guard let topRatedMovie = topRatedDetailedMovieCast else { return }
                        self.configureTopRatedDetailedMovieCastCellViewModel(detailedMovie: topRatedMovie)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    // MARK: ConfigureModel
    private func configureTopRatedDetailedMovieCastCellViewModel(detailedMovie movie: TopRatedDetailedMovieCastResponse){
        sections.append(.cast(viewModel: movie.cast.compactMap({
            return TopRatedDetailedMovieCastCellViewModel(
                adult: $0.adult,
                gender: $0.gender,
                id: $0.id,
                knownForDepartment: $0.knownForDepartment,
                name: $0.name,
                originalName: $0.originalName,
                popularity: $0.popularity,
                profilePath: $0.profilePath ?? "",
                castID: $0.castID ?? 0,
                character: $0.character ?? "",
                creditID: $0.creditID,
                order: $0.order ?? 0,
                job: $0.job
            )
        })))
        collectionView.reloadData()
    }
    
    // MARK: SetupCollectionView
    private func setupCollectionView(){
        
        collectionView.isScrollEnabled = true
        
        collectionView.register(TopRatedDetailedMoveCastCollectionViewCell.self, forCellWithReuseIdentifier: TopRatedDetailedMoveCastCollectionViewCell.identifier)
        
        collectionView.register(DetailedMovieOverviewCell.self,
            forCellWithReuseIdentifier: DetailedMovieOverviewCell.identifier)
        
        collectionView.register(
            DetailedMovieHeaderCollectionReusableCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailedMovieHeaderCollectionReusableCell.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: SetupView
    private func setupHierarchy(){
        view.addSubview(collectionView)
    }
    
    // MARK: SetUpLayout
    private func setupLayout(){
        collectionView.frame = view.bounds
    }
}


// MARK: - CollectionView
extension TopRatedMovieDetailViewController: UICollectionViewDelegate,
                                             UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let model = sections[section]
        switch model {
        case .overView(let viewModel):
            return 1
        case .cast(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section]
        switch model {
        case .overView(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailedMovieOverviewCell.identifier, for: indexPath) as? DetailedMovieOverviewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: viewModel)
            return cell
        case .cast(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopRatedDetailedMoveCastCollectionViewCell.identifier, for: indexPath) as? TopRatedDetailedMoveCastCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModel[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        
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

            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(1000)
                ),
                subitem: item,
                count: 1
            )
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .none
            return section
            
        case 1:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
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

            return section
        }
    }
}
