//
//  ActorProfile.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation


// MARK: - ACTOR DETAILS
struct ActorDetails: Codable, Hashable {
    var birthday: String?
    var known_for_department: String?
    var deathday: String?
    var id: Int
    var name: String
    var also_known_as: [String]
    var gender: Int
    var biography: String
    var popularity: Double
    var place_of_birth: String?
    var profile_path: String?
    var imdb_id: String
    var homepage: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
