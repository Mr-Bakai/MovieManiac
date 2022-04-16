//
//  AlamofireManager.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 6/1/22.
//

import Foundation
import Alamofire

enum EndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case topRated = "/movie/top_rated"
    case popular = "/movie/popular"
    case upcoming = "/movie/upcoming"
    case nowPlaying = "/movie/now_playing"
}

class AlamofireManager {
    
    typealias CompletionTopRatedMovies = ((Result<TopRatedMoviesResponse, Error>) -> Void)
    typealias CompletionPopularMovies = ((Result<PopularMoviesResponse, Error>) -> Void)
    
    typealias CompletionUpcomingMovies = ((Result<UpcomingMoviesResponse, Error>) -> Void)
    typealias CompletionNowPlayingMovies = (_ response: NowPlayingMoviesResponse?, _ error: Error?) -> ()
    
    // baseURL for TMDB
    private static let baseURLTBDM = "https://api.themoviedb.org/3"
    private static let apiKeyTBDM = "824453377136f6846fe36d6e3b773901"
    
    private static let baseURL = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    static let imageBase = "https://image.tmdb.org/t/p/w500"
    
    func getTopRatedMovies(endPoint: EndPoint, completion: @escaping CompletionTopRatedMovies){
        
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
    
    func getPopular(endPoint: EndPoint, completion: @escaping CompletionPopularMovies){
        
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
                    print(response)
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
    
    func getUpcoming(endPoint: EndPoint, completion: @escaping CompletionUpcomingMovies){
        
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
    
    func getNowPlaying(endPoint: EndPoint, completion: @escaping CompletionNowPlayingMovies){
        
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
                    completion(response, nil)
                    
                } catch let error {
                    completion(nil, error)
                }
                
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
}
