//
//  TopRatedMoviesCellViewModel.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 17/4/22.
//

import Foundation

struct TopRatedMoviesCellViewModel: Codable {
    let title: String?
    let backdropPath: String?
    let id: Int
    let overview: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
}
