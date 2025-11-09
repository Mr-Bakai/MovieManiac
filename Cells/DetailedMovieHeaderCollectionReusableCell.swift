//
//  DetailedMovieHeaderCollectionReusableCell.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 25/6/22.

import Foundation
import UIKit
import Kingfisher
import SnapKit

protocol DetailedMovieHeaderCollectionReusableCellDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: DetailedMovieHeaderCollectionReusableCell)
}

final class DetailedMovieHeaderCollectionReusableCell: UICollectionReusableView {
    static let identifier = "DetailedMovieHeaderCollectionReusableCell"
    
    private var imageBaseURL = AlamofireManager.imageBase
    weak var delegate: DetailedMovieHeaderCollectionReusableCellDelegate?
    
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
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(watchButton)
        addSubview(backButton)
        addSubview(releaseDateImageView)
        addSubview(durationLabel)
        addSubview(ratingStarImageView)
        addSubview(ratingStarLabel)
        addSubview(topLine)
        addSubview(releaseDateLabel)
        addSubview(releaseDate)
        addSubview(genreLabel)
        addSubview(bottomLine)
        addSubview(synopsisLabelTag)
        addSubview(synopsisLabel)
        addSubview(synopsisTextView)
        addSubview(collectionView)
        
        synopsisLabel.isUserInteractionEnabled = true
        synopsisLabel.addGestureRecognizer(labelTap)
    
        backButton.addTarget(self, action: #selector(navBack), for: .touchUpInside)
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

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapPlayAll(){
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
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
            maker.top.equalToSuperview()
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
            maker.top.equalToSuperview().inset(20)
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
    
    func configure(with detailedMovie: DetailedMovieResponse){
        
        setupImages(with: detailedMovie.backdropPath)
        
        var duration = detailedMovie.runtime.description ?? ""
                duration += " min"
        
        var rating = detailedMovie.voteAverage.description ?? ""
                rating += " (IMBb)"
        
        titleLabel.text = detailedMovie.title
                durationLabel.text  = duration
                ratingStarLabel.text = rating
        
        releaseDate.text = detailedMovie.releaseDate
        
                textDescriptionOfMovie = detailedMovie.overview
                synopsisLabel.appendReadmore(after: textDescriptionOfMovie, trailingContent: .readmore)
        
        
    }
}

extension DetailedMovieHeaderCollectionReusableCell {
    
    private func setupImages(with imageEndpoint: String){
        
        let URLPath = imageBaseURL + imageEndpoint
        guard let downloadURL = URL(string: URLPath) else { return }
        
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: downloadURL,
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
