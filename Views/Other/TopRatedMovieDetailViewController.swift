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

class TopRatedMovieDetailViewController: UIViewController {
    
    private let topRatedMovie: TopRatedMovie
    private var imageBaseURL = AlamofireManager.imageBase
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    init(topRatedMovie: TopRatedMovie){
        self.topRatedMovie = topRatedMovie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImages(with: topRatedMovie.posterPath)
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
    }
    
    private func setupLayout(){
        imageView.snp.makeConstraints { maker in
            maker.height.equalToSuperview()
            maker.width.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
}

// MARK: -Extension
extension TopRatedMovieDetailViewController {
    
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
