//
//  PeopleCollectionViewCell.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 31/5/22.
//

import Foundation
import UIKit
import Kingfisher
import SDWebImage

class PeopleCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    static let identifier = "PeopleCollectionViewCell"
    private var imageBaseURL = AlamofireManager.imageBaseW200
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = NSTextAlignment.center
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    public func configure(with model: PopularPeopleExploreCellViewModel){
        guard let url = model.profilePath else { return }
        label.text = model.name ?? ""
        setupImages(with: url)
    }
}

// MARK: - UI Setup
extension PeopleCollectionViewCell {
    
    private func setupUI() {
        
        imageView.snp.makeConstraints { maker in
            maker.height.equalTo(75)
            maker.width.equalTo(75)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalToSuperview()
        }
        
        label.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.top.equalTo(imageView.snp.bottom)
            maker.height.equalTo(40)
        }
    }
    
    private func setupImages(with imageEndpoint: String){
        
        let URLPath = imageBaseURL + imageEndpoint
        guard let downloadURL = URL(string: URLPath) else { return }

        let resource = ImageResource(downloadURL: downloadURL)
        let processor = RoundCornerImageProcessor(cornerRadius: 50)

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
