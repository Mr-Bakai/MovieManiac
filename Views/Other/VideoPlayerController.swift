//
//  VideoPlayerController.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 18/7/22.
import Foundation
import UIKit
import youtube_ios_player_helper
import SnapKit

class VideoPlayerController: UIViewController, YTPlayerViewDelegate {
    
    private lazy var playerView: YTPlayerView = {
        return YTPlayerView()
    }()
    private var movieId: Int
    
    init(movieId: Int){
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        fetchData()
        setupHierarchy()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    private func fetchData(){
        AlamofireManager.shared.getVideoToPlay(movieId: self.movieId,
                                 endPoint: .videoToPlay,
                                 completion: { response in
            switch response {
            case .success(let model):
                self.setupVideoKey(modelToPlay: model)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func setupHierarchy(){
        view.addSubview(playerView)
    }
    
    private func setupView(){
        view.backgroundColor = .black
        playerView.backgroundColor = .black
    }
    
    private func setupLayout(){
        playerView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.top.equalToSuperview()
            maker.height.equalTo(300)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    private func setupVideoKey(modelToPlay video: VideoResponse){
        guard !video.results.isEmpty else { return }
        self.playerView.load(withVideoId: video.results[0].key,
                             playerVars: ["playsinline":0])
        print(video.results[0].site)
    }
}
