//
//  UpcomingMovies.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - Upcoming Movies
struct UpcomingSchema: Codable {
    var page: Int
    var results: [UpcomingMovie]
    
}

struct UpcomingMovie: Codable {
    var poster_path: String?
    var overview: String
    var id: Int
    var title: String
    var backdrop_path: String?
    var popularity: Double
    var vote_average: Double
    var genre_ids: [Int]
    var release_date: String
}

