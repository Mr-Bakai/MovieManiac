//
//  PopularPeopleExploreResponse.swift.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 1/5/22.
//
import Foundation

struct PopularPeopleExploreResponse: Codable {
    let page: Int
    let results: [PopularPeopleExplore]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct PopularPeopleExplore: Codable {
    let adult: Bool
    let gender, id: Int
    let knownFor: [KnownFor]
    let knownForDepartment: KnownForDepartment
    let name: String
    let popularity: Double
    let profilePath: String

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
        case profilePath = "profile_path"
    }
}

struct KnownFor: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let mediaType: MediaType
    let originalLanguage: OriginalLanguageExplorePeople?
    let originalTitle: String?
    let overview: String
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let firstAirDate, name: String?
    let originCountry: [String]?
    let originalName: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case name
        case originCountry = "origin_country"
        case originalName = "original_name"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case person = "person"
    case tv = "tv"
}

enum OriginalLanguageExplorePeople: String, Codable {
    case en = "en"
    case ko = "ko"
    case pl = "pl"
    case th = "th"
    case tr = "tr"
    case ur = "ur"
    case ps = "ps"
}

enum KnownForDepartment: String, Codable {
    case acting = "Acting"
}

struct PopularPeopleExploreCellViewModel: Codable {
    let adult: Bool
    let gender, id: Int?
    let knownFor: [KnownFor]
    let knownForDepartment: KnownForDepartment
    let name: String?
    let popularity: Double
    let profilePath: String?
}
