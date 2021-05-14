//
//  FindMovieResults.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - FINDBY
struct FindMovieResults: Codable {
    var poster_path: String?
    var title: String
    var id: Int
    var vote_average: Double
    var genre_ids: [Int]
    var overview: String
}

struct FindPersonResults: Codable {
    var profile_path: String?
    var adult: Bool
    var id: Int
    var name: String
    var popularity: Int
//    var known_for: [KnownFor]
    
}


