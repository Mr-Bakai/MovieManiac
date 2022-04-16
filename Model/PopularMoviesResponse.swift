//
//  PopularMoviesResponse.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 10/4/22.
//

import Foundation


// MARK: - PopularMoviesResponse
struct PopularMoviesResponse: Codable {
    let page: Int
    let results: [PopularMovies]?
    let total_pages, total_results: Int

//    enum CodingKeys: String, CodingKey {
//        case page
//        case popularMovies = "results"
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
}

// MARK: - PopularMovie
struct PopularMovies: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String?
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct PopularMoviesCellViewModel {
    let backdropPath: String?
    let id: Int
    let title: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
}
