//
//  UpcomingMoviesCellViewModel.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 17/4/22.
//

import Foundation

struct UpcomingMoviesCellViewModel: Codable {
    let backdropPath: String?
    let id: Int
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
}
