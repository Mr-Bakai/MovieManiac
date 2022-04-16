//
//  MoviesViewModel.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 6/1/22.
//


final class MoviesViewModel {
    
    private let alamofire = AlamofireManager()
    var sendMovie: DataDelegateProtocol? = nil
    
    func getTopRatedMovies(){
        alamofire.getTopRatedMovies(endPoint: .topRated, completion: { response in
            switch response {
            case .success(let model):
                self.sendMovie?.movieResponse(movie: model)
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

