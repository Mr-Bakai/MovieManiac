//
//  PeopleCollectionViewCell.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 31/5/22.
//

import Foundation
import UIKit
import Kingfisher

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
    
    public func configure(with model: PeopleCellViewModel){
        guard let url = model.profilePath else {
            label.text = model.name
            // James Stalker ===== JS
            // Here take two full name and take first letters and stick them
            return
        }
        setupImages(with: url)
        label.text = model.name
    }
}

// MARK: - UI Setup
extension PeopleCollectionViewCell {
    
    override func prepareForReuse() {
        imageView.image = nil
        label.text = nil
    }
    
    private func setupUI() {
        
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 5
        
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
