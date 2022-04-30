//
//  NowPlayingMoviesResponse.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 10/4/22.
//

import Foundation

// MARK: - NowPlayingMoviesResponse
struct NowPlayingMoviesResponse: Codable {
    let dates: Dates
    let page: Int
    let nowPlayingMovies: [NowPlayingMovie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page
        case nowPlayingMovies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - NowPlayingMovie
struct NowPlayingMovie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
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

struct NowPlayingMoviesCellViewModel: Codable {
    let backdropPath: String?
    let id: Int
    let overview: String
    let posterPath, title: String
    let voteAverage: Double
    let voteCount: Int
}
