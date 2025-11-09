//
//  TopRatedMovieDetailViewController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 8/6/22.

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
        case .cast: return "Cast and Crew"
        }
    }
}

class TopRatedMovieDetailViewController: UIViewController {
    
    private var sections = [DetailedMovieSectionType]()
    
    private var topRatedMovie: TopRatedMoviesCellViewModel
    private var detailedMovie: DetailedMovieResponse?
    
    private var imageBaseURL = AlamofireManager.imageBase
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ ->
        NSCollectionLayoutSection? in
        return TopRatedMovieDetailViewController.createSectionLayout(section: sectionIndex)
    })
    
    init(movie: TopRatedMoviesCellViewModel) {
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
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: SetupView
    private func setupHierarchy(){
        view.addSubview(collectionView)
    }
    
    // MARK: SetUpLayout
    private func setupLayout(){
        collectionView.frame = view.bounds
    }
    
    // MARK: FetchData
    private func fetchData(){
        
        var topRatedDetailedMovieCast: TopRatedDetailedMovieCastResponse?
        
        AlamofireManager.shared.getDetailedMovie(movieId: topRatedMovie.id,
                                   endPoint: .detailedMovie,
                                   completion: { response in
            switch response {
            case .success(let detailedMovieModel):
                self.detailedMovie = detailedMovieModel
                self.configureTopRatedDetailedMovieCellViewModel(topRatedMovie: detailedMovieModel)
                
                AlamofireManager.shared.getTopRatedDetailedMovieCast(movieId: detailedMovieModel.id,
                                                            endPoint: .topRatedDetailedMovieCast,
                                                            completion: { response in
                    switch response {
                    case .success(let castModel):
                        topRatedDetailedMovieCast = castModel
                        guard let topRatedMovie = topRatedDetailedMovieCast else { return }
                        self.configureTopRatedDetailedMovieCastCellViewModel(detailedMovieCast: topRatedMovie)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            case .failure(let error):
                print(error.localizedDescription)
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    // MARK: ConfigureModels
    fileprivate func configureTopRatedDetailedMovieCellViewModel(topRatedMovie movie: (DetailedMovieResponse)) {
        self.sections.append(.overView(viewModel: DetailedMovieOverviewCellViewModel(
                                        adult: movie.adult,
                                        backdropPath: movie.backdropPath,
                                        budget: movie.budget,
                                        genres: movie.genres,
                                        homepage: movie.homepage,
                                        id: movie.id,
                                        imdbID: movie.imdbID,
                                        originalLanguage: movie.originalLanguage,
                                        originalTitle: movie.originalTitle,
                                        overview: movie.overview,
                                        popularity: movie.popularity,
                                        posterPath: movie.posterPath,
                                        productionCompanies: movie.productionCompanies,
                                        productionCountries: movie.productionCountries,
                                        releaseDate: movie.releaseDate,
                                        revenue: movie.revenue,
                                        runtime: movie.runtime,
                                        spokenLanguages: movie.spokenLanguages,
                                        status: movie.status,
                                        tagline: movie.tagline,
                                        title: movie.title,
                                        video: movie.video,
                                        voteAverage: movie.voteAverage,
                                        voteCount: movie.voteCount)))
    }
    
    fileprivate func configureTopRatedDetailedMovieCastCellViewModel(detailedMovieCast movieCast: TopRatedDetailedMovieCastResponse){
        self.sections.append(.cast(viewModel: movieCast.cast.compactMap({
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
            TitleHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeaderCollectionReusableView.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: NavBack and PlayVideo
extension TopRatedMovieDetailViewController: DetailedMovieOverviewCellDidTapBackDelegate,
                                             DetailedMovieOverviewCellDidTapWatchButtonDelegate {
    
    func detailedMovieOverviewCellDidTapWatch(_ header: DetailedMovieOverviewCell) {
        guard let movie = self.detailedMovie else { return }
        // TODO: Do not present VideoPlayer controller if there is no video to load
        // TODO: Do show something if video is nil (hide the button or something like this)
        let vc = VideoPlayerController(movieId: movie.id)
        vc.title = movie.title
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func detailedMovieOverviewCellDidTapBack(_ header: DetailedMovieOverviewCell) {
        navigationController?.popViewController(animated: true)
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
        case .overView(_):
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
            cell.delegateNavBack = self
            cell.delegateWatchVideo = self
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
    
    // MARK: - HeaderView
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        
        if sections[indexPath.section].title == "Overview" {
            // TODO: Check if you can change the size of the NSCollectionLayoutBoundarySupplementaryItem dynamically depending on which section you are in
            header.isHidden = true
            return header
        } else {
            header.isHidden = false
            return header
        }
    }
}

extension TopRatedMovieDetailViewController {
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
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(700)
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
            section.orthogonalScrollingBehavior = .continuous
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

            return section
        }
    }
}
