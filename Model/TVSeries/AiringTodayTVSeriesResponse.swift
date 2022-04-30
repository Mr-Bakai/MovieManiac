//
//  AiringTodayTVSeriesResponse.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 30/4/22.
//

import Foundation

struct AiringTodayTVSeriesResponse: Codable {
    let page: Int?
    let results: [AiringTodayTVSeries]?
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct AiringTodayTVSeries: Codable {
    let backdropPath: String?
    let firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct AiringTodayTVSeriesCellViewModel {
    let backdropPath: String?
    let id: Int
    let overview: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
}
