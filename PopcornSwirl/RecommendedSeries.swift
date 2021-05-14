//
//  RecommendedSeries.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - Similar Shows to TVSeries
struct SimilarSeriesSchema: Codable {
    var page: Int
    var results: [SimilarSeries]
}

struct SimilarSeries: Codable {
    var poster_path: String?
    var popularity: Int
    var id: Int
    var vote_average: Double
    var overview: String
    var first_air_date: String
    var genre_ids: [Int]
    var name: String
    
}


