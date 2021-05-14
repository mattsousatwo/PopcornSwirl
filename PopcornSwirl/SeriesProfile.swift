//
//  SeriesProfile.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - TV Series Details
struct SeriesDetail: Codable {
    var first_air_date: String?
    var genres: [Int]?
    var id: Int?
    var name: String?
    var number_of_episodes: Int?
    var number_of_seasons: Int?
    var overview: String?
    var poster_path: String?
    var vote_average: Double?
}

