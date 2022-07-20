//
//  VideoToPlay.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 18/7/22.
//
import Foundation

struct VideoResponse: Codable {
    let id: Int
    let results: [VideoToPlay]
}

struct VideoToPlay: Codable {
    let iso639_1, iso3166_1, name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}
