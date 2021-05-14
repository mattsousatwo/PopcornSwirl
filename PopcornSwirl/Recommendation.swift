//
//  Recommendation.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - Recommendations
struct Recommendation: Codable {
    var page: Int?
    var results:  [RecommendedMovie]?
}

struct RecommendedMovie: Codable, Equatable {
    var title: String
    var poster_path: String?
    var overview: String
    var popularity: Double
    var id: Int?
    var vote_average: Double
    var genre_ids: [Int]
    var release_date: String?

    // Equatable
    static func ==(lhs: RecommendedMovie, rhs: RecommendedMovie) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.poster_path == rhs.poster_path &&
            lhs.popularity == rhs.popularity &&
            lhs.overview == rhs.overview &&
            lhs.id == rhs.id &&
            lhs.vote_average == rhs.vote_average &&
            lhs.genre_ids == rhs.genre_ids &&
            lhs.release_date == rhs.release_date
    }

}
