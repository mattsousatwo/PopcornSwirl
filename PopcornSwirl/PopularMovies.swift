//
//  PopularMovies.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - Popular Coding Keys
struct Popular: Codable {
    public var page: Int
    public var results: [PopMovie]
}
 

class PopMovie: Codable, Identifiable {
    public var id: Int
    public var title: String
    public var overview: String
    public var poster_path: String
    public var vote_average: Double
    public var genre_ids: [Int]
    public var release_date: String
    public var backdrop_path: String?
}

