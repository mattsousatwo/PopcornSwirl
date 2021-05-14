//
//  ActorCredits.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - ACTOR CREDITS
struct ActorCredits: Codable {
    var cast: [ActorCreditsCast]?
    var id: Int?
}

struct ActorCreditsCast: Codable, Hashable {
    var id: Int?
    var overview: String
    var genre_ids: [Int]
    var name: String?
    var media_type: String
    var poster_path: String?
    var vote_average: Double
    var character: String
    var title: String?
    var release_date: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


