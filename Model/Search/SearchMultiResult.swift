//
//  SearchMultiResult.swift
//  MovieManiac
//
//  Created by Bakai Ismailov on 25/5/22.
//

import Foundation

enum SearchMultiResult {
    case movie(model: SearchMulti)
    case tv(model: SearchMulti)
    case person(model: SearchMulti)
}
