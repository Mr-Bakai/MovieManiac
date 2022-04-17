//
//  PopularMoviesCellViewModel.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 17/4/22.
//

import Foundation

struct PopularMoviesCellViewModel {
    let backdropPath: String?
    let id: Int
    let title: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
}
