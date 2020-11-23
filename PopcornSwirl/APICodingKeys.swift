//
//  APICodingKeys.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 11/20/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation

struct NowPlaying: Codable {
    var page: Int
    var results: [Results]
}


struct Results: Codable {
    var poster_path: String
    var adult: Bool
    var overview: String
    var release_date: String
//    var genre_ids: [GenreIDs]
    var id: Int
    var original_title: String
    var original_language: String
    var title: String
    var backdrop_path: String
    var popularity: Double
    var vote_count: Double 
    var video: Bool
    var vote_average: Double
}
