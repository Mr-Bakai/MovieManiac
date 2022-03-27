//
//  MoviesViewModel.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 6/1/22.
//


final class MoviesViewModel {
    private let alamo = AlamofireManager()
    var sendMovie: DataDelegateProtocol? = nil
    
    func getTopRatedMovies(){
        alamo.getTopRatedMovies(endPoint: .topRated, completion: { (response, error) in
            guard let res = response else { return }
            self.sendMovie?.movieResponse(movie: res)
        })
    }
}
