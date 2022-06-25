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
    case cast(viewModel: [TopRatedDetailedMovieCastCellViewModel])
    
    var title: String {
        switch self {
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
    
    private var textDescriptionOfMovie = ""
    
    lazy var labelTap = UITapGestureRecognizer(target: self, action: #selector(didTapReadMoreLess(_:)))
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{ sectionIndex, _ ->
        NSCollectionLayoutSection? in
        return TopRatedMovieDetailViewController.createSectionLayout(section: sectionIndex)
    })
    
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemBackground
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        image.contentMode = .scaleToFill
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Tenant"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let watchButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(systemName: "play.fill")
        button.setImage(icon, for: .normal)
        button.tintColor = .white
        
        button.layer.cornerRadius = 50/2
        button.layer.masksToBounds = true
        button.backgroundColor = .systemRed
        
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(systemName: "chevron.backward")
        button.setImage(icon, for: .normal)
        
        button.tintColor = .white
        let exampleColor = UIColor.black
        button.backgroundColor = exampleColor.withAlphaComponent(0.2)
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let releaseDateImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "clock")
        image.backgroundColor = .systemBackground
        image.tintColor = .gray
        
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        
        image.contentMode = .scaleToFill
        return image
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.text = "Release Date"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let ratingStarImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "star.fill")
        image.backgroundColor = .systemBackground
        image.tintColor = .gray
        
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        
        image.contentMode = .scaleToFill
        return image
    }()
    
    
    private let ratingStarLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.text = "Rating"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    
    private let topLine: UIView = {
        let line = UIView()
        let lineColor = UIColor.gray
        line.backgroundColor = lineColor.withAlphaComponent(0.2)
        return line
    }()
    
    private let bottomLine: UIView = {
        let line = UIView()
        let lineColor = UIColor.gray
        line.backgroundColor = lineColor.withAlphaComponent(0.2)
        return line
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Release Date"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let releaseDate: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Genre"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let synopsisLabelTag: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Synopsis"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let synopsisLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let synopsisTextView: UITextView = {
        let label = UITextView()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    
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
        setupImages(with: topRatedMovie.posterPath)
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
    
    // MARK: FetchData
    private func fetchData(){
        
        var topRatedDetailedMovieCast: TopRatedDetailedMovieCastResponse?
            
        alamofire.getDetailedMovie(movieId: topRatedMovie.id,
                                   endPoint: .detailedMovie,
                                   completion: { response in
            switch response {
            case .success(let model):
                // TODO: Convert to local model
                self.detailedMovie = model
                self.setupRest()
                
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
        // Register cells here
        
        collectionView.isScrollEnabled = false
        
        collectionView.register(TopRatedDetailedMoveCastCollectionViewCell.self, forCellWithReuseIdentifier: TopRatedDetailedMoveCastCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: SetupView
    private func setupHierarchy(){
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(watchButton)
        view.addSubview(backButton)
        view.addSubview(releaseDateImageView)
        view.addSubview(durationLabel)
        view.addSubview(ratingStarImageView)
        view.addSubview(ratingStarLabel)
        view.addSubview(topLine)
        view.addSubview(releaseDateLabel)
        view.addSubview(releaseDate)
        view.addSubview(genreLabel)
        view.addSubview(bottomLine)
        view.addSubview(synopsisLabelTag)
        view.addSubview(synopsisLabel)
        view.addSubview(synopsisTextView)
        view.addSubview(collectionView)
        
        synopsisLabel.isUserInteractionEnabled = true
        synopsisLabel.addGestureRecognizer(labelTap)
        
        backButton.addTarget(self, action: #selector(navBack), for: .touchUpInside)
    }
    
    // MARK: - SetupRest
    private func setupRest(){
        
        //TODO: Excel this optional cases
        
        var duration = detailedMovie?.runtime.description ?? ""
        duration += " min"
        
        var rating = detailedMovie?.voteAverage.description ?? ""
        rating += " (IMBb)"
        
        titleLabel.text = detailedMovie?.title
        durationLabel.text  = duration
        ratingStarLabel.text = rating
        
        releaseDate.text = detailedMovie?.releaseDate
        
        guard let textDesc = detailedMovie?.overview else {
            return
        }
        
        textDescriptionOfMovie = textDesc
        synopsisLabel.appendReadmore(after: textDescriptionOfMovie, trailingContent: .readmore)
    }
    
    @objc func didTapReadMoreLess(_ sender: UITapGestureRecognizer) {
            guard let text = synopsisLabel.text else { return }
        
            let readmore = (text as NSString).range(of: TrailingContent.readmore.text)
            let readless = (text as NSString).range(of: TrailingContent.readless.text)
        
            if sender.didTap(label: synopsisLabel, inRange: readmore) {
                synopsisLabel.appendReadLess(after: textDescriptionOfMovie, trailingContent: .readless)
            } else if  sender.didTap(label: synopsisLabel, inRange: readless) {
                synopsisLabel.appendReadmore(after: textDescriptionOfMovie, trailingContent: .readmore)
            } else { return }
        }
    
    @objc func navBack(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: SetUpLayout
    private func setupLayout(){
        // TODO: Find Circle rating with integer
        
        let initialColor = UIColor.black
        let middleColor = UIColor.gray
        let finalColor = UIColor.clear
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [initialColor.cgColor,
                                middleColor.cgColor,
                                finalColor.cgColor
        ]
        gradientLayer.locations = [0.2, 0.4, 1]
        gradientLayer.frame = imageView.bounds
        imageView.layer.mask = gradientLayer
        
        imageView.snp.makeConstraints { maker in
            maker.height.equalTo(400)
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.width.equalTo(277)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(watchButton.snp.bottom).offset(20)
        }
        
        watchButton.snp.makeConstraints { maker in
            maker.height.width.equalTo(50)
            maker.bottom.equalTo(imageView.snp.bottom).inset(20)
            maker.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(36)
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            maker.left.equalToSuperview().offset(20)
        }
        
        releaseDateImageView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(20)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        durationLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(releaseDateImageView.snp.centerY)
            maker.left.equalTo(releaseDateImageView.snp.right).offset(3)
            maker.height.equalTo(20)
        }
        
        ratingStarImageView.snp.makeConstraints { maker in
            maker.centerY.equalTo(releaseDateImageView.snp.centerY)
            maker.left.equalTo(durationLabel.snp.right).offset(20)
        }
        
        ratingStarLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(ratingStarImageView.snp.centerY)
            maker.left.equalTo(ratingStarImageView.snp.right).offset(3)
        }
        
        topLine.snp.makeConstraints { maker in
            maker.height.equalTo(1)
            maker.top.equalTo(releaseDateImageView.snp.bottom).offset(16)
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().inset(20)
        }
        
        releaseDateLabel.snp.makeConstraints { maker in
            maker.top.equalTo(topLine.snp.bottom).offset(16)
            maker.left.equalToSuperview().offset(20)
        }
        
        releaseDate.snp.makeConstraints { maker in
            maker.top.equalTo(releaseDateLabel.snp.bottom).offset(12)
            maker.left.equalToSuperview().offset(20)
        }
        
        genreLabel.snp.makeConstraints { maker in
            maker.top.equalTo(topLine.snp.bottom).offset(16)
            maker.left.equalTo(releaseDateLabel.snp.right).offset(56)
        }
        
        bottomLine.snp.makeConstraints { maker in
            maker.height.equalTo(1)
            maker.top.equalTo(releaseDate.snp.bottom).offset(16)
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().inset(20)
        }
        
        synopsisLabelTag.snp.makeConstraints { maker in
            maker.top.equalTo(bottomLine.snp.bottom).offset(16)
            maker.left.equalToSuperview().offset(20)
        }
        
        synopsisLabel.snp.makeConstraints { maker in
            maker.top.equalTo(synopsisLabelTag.snp.bottom).offset(14)
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(synopsisLabel.snp.bottom).offset(10)
            maker.right.left.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
    }
}

// MARK: - Extension
extension TopRatedMovieDetailViewController {
    
    private func setupImages(with imageEndpoint: String){
        
        let URLPath = imageBaseURL + imageEndpoint
        guard let downloadURL = URL(string: URLPath) else { return }
        
        let resource = ImageResource(downloadURL: downloadURL)
        
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: resource,
                                   options: [
                                             .cacheSerializer(FormatIndicatedCacheSerializer.png)]) { (result) in
            self.handle(result)
        }
    }
    
    func handle(_ result: Result<RetrieveImageResult, KingfisherError>){
        
        switch result {
        case .success(let retrieveImageResult):
            let image = retrieveImageResult.image
            imageView.image = image
        case .failure(let err):
            print(err)
        }
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
        case .cast(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section]
        switch model {
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
            
//            // Vertical group in horizontal group
//            let verticalGroup = NSCollectionLayoutGroup.vertical(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .absolute(390)
//                ),
//                subitem: item,
//                count: 1
//            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.75),
                    heightDimension: .absolute(390)
                ),
                subitem: item,
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
