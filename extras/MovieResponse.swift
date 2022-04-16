//
//  MovieResponse.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 6/1/22.
//

import Foundation

// MARK: - MovieResponse
//class MovieResponse: Codable {
//    let page: Int
//    let results: [TopRatedMovies]
//    let totalPages, totalResults: Int
//
//    enum CodingKeys: String, CodingKey {
//        case page, results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
//}
//
//// MARK: - Result
//class TopRatedMovies: Codable {
//    let adult: Bool
//    let backdropPath: String
//    let genreIDS: [Int]
//    let id: Int
//    let originalLanguage, originalTitle, overview: String
//    let popularity: Double
//    let posterPath, releaseDate, title: String
//    let video: Bool
//    let voteAverage: Double
//    let voteCount: Int
//
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview, popularity
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//}
//
//extension TopRatedMovies: Equatable {
//    static func == (lhs: TopRatedMovies, rhs: TopRatedMovies) -> Bool {
//        // Two photos are the same if they have the same photoID
//        return lhs.id == rhs.id
//    }
//}
