//
//  MovieSearch.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - Search Results
struct MovieSearch: Codable {
    var page: Int?
    var results: [MovieSearchResults]?
}

struct MovieSearchResults: Codable, Hashable {
    var poster_path: String?
    var adult: Bool
    var overview: String
    var id: Int
    var title: String
    var backdrop_path: String?
    var popularity: Double
    var vote_average: Double
    var genre_ids: [Int]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

