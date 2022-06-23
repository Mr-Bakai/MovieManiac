//
//  AlamofireManager.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 6/1/22.
//

import Foundation
import Alamofire

enum MoviesEndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case topRated = "/movie/top_rated"
    case popular = "/movie/popular"
    case upcoming = "/movie/upcoming"
    case nowPlaying = "/movie/now_playing"
    case detailedMovie = "/movie/"
}

enum TVSeriesEndPoint: String {
    case airingTodayTVSeries = "/tv/airing_today"
    case popularTVSeries = "/tv/popular"
    case topRatedTVSeries = "/tv/top_rated"
}

enum OtherEndPoints: String{
    case popularPeople = "/person/popular"
    case multiSearch = "/search/multi"
}

class AlamofireManager {
    
    typealias CompletionTopRatedMovies = ((Result<TopRatedMoviesResponse, Error>) -> Void)
    typealias CompletionPopularMovies = ((Result<PopularMoviesResponse, Error>) -> Void)
    typealias CompletionUpcomingMovies = ((Result<UpcomingMoviesResponse, Error>) -> Void)
    typealias CompletionNowPlayingMovies = ((Result<NowPlayingMoviesResponse, Error>) -> Void)
    
    typealias CompletionAiringTodayTVSeries = ((Result<AiringTodayTVSeriesResponse, Error>) -> Void)
    typealias CompletionPopularTVSeries = ((Result<PopularTVSeriesResponse, Error>) -> Void)
    typealias CompletionTopRatedTVSeries = ((Result<TopRatedTVSeriesResponse, Error>) -> Void)
    typealias CompletionPopularPeopleExplore = ((Result<PopularPeopleExploreResponse, Error>) -> Void)
    
    typealias CompletionMultiSearch = ((Result<SearchMultiResponse, Error>) -> Void)
    typealias CompletionDetailedMovie = ((Result<DetailedMovieResponse, Error>) -> Void)
    
    
    // baseURL for TMDB
    private static let baseURLTBDM = "https://api.themoviedb.org/3"
    private static let apiKeyTBDM = "824453377136f6846fe36d6e3b773901"
    
    private static let baseURL = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    static let imageBase = "https://image.tmdb.org/t/p/w500"
    static let imageBaseW200 = "https://image.tmdb.org/t/p/w200"
    
    
    // MARK: - TopRatedMovies
    func getTopRatedMovies(endPoint: MoviesEndPoint, completion: @escaping CompletionTopRatedMovies){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM ] as [String:Any]
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { (responseJSON) in
                
                switch responseJSON.result {
                case .success:
                    print("Success")
                    guard let data = responseJSON.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(TopRatedMoviesResponse.self, from: data)
                        completion(.success(response))
                        
                    } catch let error {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - PopularMovies
    func getPopular(endPoint: MoviesEndPoint, completion: @escaping CompletionPopularMovies){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM ] as [String:Any]
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { (responseJSON) in
                
                switch responseJSON.result {
                case .success:
                    print("Success")
                    guard let data = responseJSON.data else { return }
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(PopularMoviesResponse.self, from: data)
                        completion(.success(response))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - UpcomingMovies
    func getUpcoming(endPoint: MoviesEndPoint, completion: @escaping CompletionUpcomingMovies){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM ] as [String:Any]
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { (responseJSON) in
                
                switch responseJSON.result {
                case .success:
                    print("Success")
                    guard let data = responseJSON.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(UpcomingMoviesResponse.self, from: data)
                        completion(.success(response))
                        
                    } catch let error {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - NowPlayingMovies
    func getNowPlaying(endPoint: MoviesEndPoint, completion: @escaping CompletionNowPlayingMovies){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM ] as [String:Any]
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { (responseJSON) in
                
                switch responseJSON.result {
                case .success:
                    print("Success")
                    guard let data = responseJSON.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(NowPlayingMoviesResponse.self, from: data)
                        completion(.success(response))
                        
                    } catch let error {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - AiringTodayTVSeries
    func getAiringToday(endPoint: TVSeriesEndPoint, completion: @escaping CompletionAiringTodayTVSeries){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM] as [String:Any]
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { (responseJSON) in
                
                switch responseJSON.result {
                case .success:
                    print("Success")
                    guard let data = responseJSON.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(AiringTodayTVSeriesResponse.self, from: data)
                        completion(.success(response))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - PopularTVSeries
    func getPopularTVSeries(endPoint: TVSeriesEndPoint, completion: @escaping CompletionPopularTVSeries){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM] as [String:Any]
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { (responseJSON) in
                
                switch responseJSON.result {
                case .success:
                    print("Success")
                    guard let data = responseJSON.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(PopularTVSeriesResponse.self, from: data)
                        completion(.success(response))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - TopRatedTVSeries
    func getTopRatedTVSeries(endPoint: TVSeriesEndPoint, completion: @escaping CompletionTopRatedTVSeries){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM] as [String:Any]
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { (responseJSON) in
                
                switch responseJSON.result {
                case .success:
                    print("Success")
                    guard let data = responseJSON.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(TopRatedTVSeriesResponse.self, from: data)
                        completion(.success(response))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - PopularPeopleExplore
    func getPopularPeopleExplore(endPoint: OtherEndPoints, completion: @escaping CompletionPopularPeopleExplore){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM] as [String:Any]
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { (responseJSON) in
                
                switch responseJSON.result {
                case .success:
                    print("Success")
                    guard let data = responseJSON.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(PopularPeopleExploreResponse.self, from: data)
                        completion(.success(response))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - PopularMovies
    func makeMultiSearch(searchFor with: String,
                         endPoint: OtherEndPoints,
                         completion: @escaping CompletionMultiSearch){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM,"language": "en-US", "query": with] as [String:Any]
        
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { responseJSON in
                
                switch responseJSON.result {
                case .success:
                    print("SuccessIn Multi Search")
                    guard let data = responseJSON.data else {
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(SearchMultiResponse.self, from: data)
                        
                        completion(.success(response))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        
    }
    
    // MARK: - DetailedMovie
    func getDetailedMovie(movieId with: Int,
                         endPoint: MoviesEndPoint,
                         completion: @escaping CompletionDetailedMovie){
        
        let params = ["api_key" : AlamofireManager.apiKeyTBDM] as [String:Any]
        
        AF.request(AlamofireManager.baseURLTBDM + endPoint.rawValue + "\(with)",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: nil, interceptor: nil)
            .response { responseJSON in
                
                switch responseJSON.result {
                case .success:
                    print("SuccessIn DetailedMovie")
                    guard let data = responseJSON.data else {
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(DetailedMovieResponse.self, from: data)
                        
                        completion(.success(response))
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        
        
    }
}
