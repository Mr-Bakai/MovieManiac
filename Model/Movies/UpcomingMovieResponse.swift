//
//  UpcomingMovieResponse.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 10/4/22.
//

import Foundation
import UIKit

// MARK: - UpcomingMoviesResponse
struct UpcomingMoviesResponse: Codable {
    let dates: Dates
    let page: Int
    let upcomingMovies: [UpcomingMovies]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case upcomingMovies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - UpcomingMovie
struct UpcomingMovies: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
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
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
