//
//  MainViewModel.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 30/7/22.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let service = AlamofireManager.shared
    
    var getPopularMoviesBR = BehaviorRelay<[PopularMoviesCellViewModel]>(value: [PopularMoviesCellViewModel]())
    var popularMoviesResponse: PopularMoviesResponse?
    
    var getTopRatedMoviesBR = BehaviorRelay<[TopRatedMoviesCellViewModel]>(value: [TopRatedMoviesCellViewModel]())
    var topRatedMoviesResponse: TopRatedMoviesResponse?
    
    var getUpcomingMoviesBR = BehaviorRelay<[UpcomingMoviesCellViewModel]>(value: [UpcomingMoviesCellViewModel]())
    var upcomingMoviesResponse: UpcomingMoviesResponse?
    
    var getNowPlayingMoviesBR = BehaviorRelay<[NowPlayingMoviesCellViewModel]>(value: [NowPlayingMoviesCellViewModel]())
    var nowPlayingMoviesResponse: NowPlayingMoviesResponse?
    
    func getPopularMovies(){
        service.getPopular(endPoint: .popular, completion: { response in
            switch response {
            case .success(let model):
                self.popularMoviesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            guard let popularMovies = self.popularMoviesResponse?.results else { return }
            self.configurePopularMoviesModel(popularMovies: popularMovies)
        })
    }
    
    func getTopRatedMovies(){
        service.getTopRatedMovies(endPoint: .topRated, completion: { response in
            switch response {
            case .success(let model):
                self.topRatedMoviesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            guard let topRatedMovies = self.topRatedMoviesResponse?.results else { return }
            self.configureTopRatedMoviesModel(topRatedMovies: topRatedMovies)
        })
    }
    
    func getUpcomingMovies(){
        service.getUpcoming(endPoint: .upcoming, completion: { response in
            switch response{
            case .success(let model):
                self.upcomingMoviesResponse = model
            case .failure(let error):
                print(error.localizedDescription)
            }
            guard let upcomingMovies = self.upcomingMoviesResponse?.upcomingMovies else { return }
            self.configureUpcomingMoviesModel(upcomingMovies: upcomingMovies)
        })
    }
    
    func getNowPlayingMovies(){
        service.getNowPlaying(endPoint: .nowPlaying, completion: { response in
            switch response{
            case .success(let model):
                self.nowPlayingMoviesResponse = model
            case .failure(let error):
            print(error.localizedDescription)
            }
            
            guard let nowPlayingMovies = self.nowPlayingMoviesResponse?.nowPlayingMovies else { return }
            self.configureNowPlayingMoviesModel(nowPlayingMovies: nowPlayingMovies)
        })
    }
    
    private func configurePopularMoviesModel(popularMovies: [PopularMovies]){
        let popularMovies = popularMovies.compactMap({
            return PopularMoviesCellViewModel(
                backdropPath: $0.posterPath ?? "",
                id: $0.id ,
                title: $0.title ?? "",
                popularity: $0.popularity ,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount)
        })
        self.getPopularMoviesBR.accept(popularMovies)
    }
    
    private func configureTopRatedMoviesModel(topRatedMovies: [TopRatedMovie]){
            let topRatedMovies = topRatedMovies.compactMap({
                return TopRatedMoviesCellViewModel(
                    title: $0.title ,
                    backdropPath: $0.posterPath,
                    id: $0.id,
                    overview: $0.overview,
                    popularity: $0.popularity,
                    voteAverage: $0.voteAverage,
                    voteCount: $0.voteCount)
            })
        self.getTopRatedMoviesBR.accept(topRatedMovies)
    }
    
    private func configureUpcomingMoviesModel(upcomingMovies: [UpcomingMovies]){
        let upcomingMovies = upcomingMovies.compactMap({
            return UpcomingMoviesCellViewModel(
                backdropPath: $0.posterPath ?? "",
                id: $0.id,
                overview: $0.overview,
                posterPath: $0.posterPath,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount)
        })
        self.getUpcomingMoviesBR.accept(upcomingMovies)
    }
    
    private func configureNowPlayingMoviesModel(nowPlayingMovies: [NowPlayingMovie]){
       let nowPlaying = nowPlayingMovies.compactMap({
            return NowPlayingMoviesCellViewModel(
                backdropPath: $0.posterPath,
                id: $0.id,
                overview: $0.overview,
                posterPath: $0.posterPath,
                title: $0.title,
                voteAverage: $0.voteAverage,
                voteCount: $0.voteCount
            )
        })
        self.getNowPlayingMoviesBR.accept(nowPlaying)
    }
}
