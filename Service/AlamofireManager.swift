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
    
    typealias Completion = (_ response: MovieResponse?, _ error: Error?) -> ()
    
    // baseURL for TMDB
    private static let baseURLTBDM = "https://api.themoviedb.org/3"
    private static let apiKeyTBDM = "824453377136f6846fe36d6e3b773901"
    
    private static let baseURL = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    static let imageBase = "https://image.tmdb.org/t/p/w500"
    
    func getTopRatedMovies(endPoint: EndPoint, completion: @escaping Completion){
        
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
                    let response = try decoder.decode(MovieResponse.self, from: data)
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
    
    func getPopular(endPoint: EndPoint, completion: @escaping Completion){
        
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
                    let response = try decoder.decode(MovieResponse.self, from: data)
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
    
    func getUpcoming(endPoint: EndPoint, completion: @escaping Completion){
        
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
                    let response = try decoder.decode(MovieResponse.self, from: data)
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
    
    func getNowPlaying(endPoint: EndPoint, completion: @escaping Completion){
        
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
                    let response = try decoder.decode(MovieResponse.self, from: data)
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
