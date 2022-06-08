//
//  SearchMultiResult.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 25/5/22.
//

import Foundation

enum SearchMultiResult {
    // Check this if you can make different model for this (PopularMovies)
    case movie(model: SearchMulti)
    case tv(model: SearchMulti)
    case person(model: SearchMulti)
}
