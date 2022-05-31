//
//  PopularTVSeriesResponse.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 1/5/22.
//

import Foundation

// MARK: - Welcome
struct PopularTVSeriesResponse: Codable {
    let page: Int
    let results: [PopularTVSeries]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct PopularTVSeries: Codable {
    let backdropPath, firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage: OriginalLanguagePopularTVSeries
    let originalName, overview: String
    let popularity: Double
    let posterPath: String
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

enum OriginalLanguagePopularTVSeries: String, Codable {
    case ar = "ar"
    case en = "en"
    case es = "es"
}

struct PopularTVSeriesCellViewModel {
    let backdropPath: String?
    let id: Int
    let overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
}
