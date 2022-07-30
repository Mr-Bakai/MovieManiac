//
//  PopularMoviesCollectionViewCell.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 17/4/22.
//

import Foundation
import UIKit
import Kingfisher

class PopularMoviesCollectionViewCell: UICollectionViewCell {
    
    private let ratingView = RatingCustomView()
    private let imageView = UIImageView()
    static let identifier = "PopularMoviesCollectionViewCell"
    private var imageBaseURL = AlamofireManager.imageBase
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(ratingView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    public func configure(with model: PopularMoviesCellViewModel){
        guard let url = model.backdropPath else { return }
        setupImages(with: url)
        setupLabel(model)
    }
}

// MARK: - UI Setup
extension PopularMoviesCollectionViewCell {
    
    private func setupUI() {
        imageView.snp.makeConstraints { maker in
            maker.height.equalToSuperview()
            maker.width.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    fileprivate func setupLabel(_ model: PopularMoviesCellViewModel) {
        var str = "\(model.voteAverage)"
        if let dotRange = str.range(of: ".") {
            str.removeSubrange(dotRange.lowerBound..<str.endIndex)
        }
        ratingView.label.text = str
    }
    
    private func setupImages(with imageEndpoint: String){
        
        let URLPath =  imageBaseURL + imageEndpoint
        guard  let downloadURL = URL(string: URLPath) else { return }

        let resource = ImageResource(downloadURL: downloadURL)
        let processor = RoundCornerImageProcessor(cornerRadius: 20)

        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: resource,
                                   options: [.processor(processor),
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
