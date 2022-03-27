//
//  MoviesCollectionViewCell.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 6/1/22.
//

import UIKit
import Kingfisher

class MoviesCollectionViewCell: UICollectionViewCell {
    
    
    private let imageView = UIImageView()
    static let identifier = "MoviesCollectionViewCell"
    private var imageBaseURL = AlamofireManager.imageBase
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    public func configure(with model: TopRatedMovies){
        setupImages(with: model.backdropPath)
    }
}

// MARK: - UI Setup
extension MoviesCollectionViewCell {
    
    private func setupUI() {
        
        self.contentView.addSubview(imageView)
        
        
        imageView.snp.makeConstraints { maker in
//            maker.height.equalToSuperview()
//            maker.width.equalToSuperview()
            maker.left.equalToSuperview()
//            maker.right.equalToSuperview()
//            maker.top.equalToSuperview()
//            maker.bottom.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
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
            let cacheType = retrieveImageResult.cacheType
            let source = retrieveImageResult.source
            let originalSource = retrieveImageResult.originalSource
            
            imageView.image = image
            print(cacheType)
            print(source)
            print(originalSource)
            
        case .failure(let err):
            print(err)
        }
    }
}
