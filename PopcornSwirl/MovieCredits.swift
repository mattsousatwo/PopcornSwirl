//
//  MovieCredits.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - Movie Credits
struct MovieCredits: Codable {
    var id: Int
    var cast: [MovieCast]?
    var crew: [MovieCrew]
}

struct MovieCast: Codable, Equatable {
    var id: Int
    var known_for_department: String?
    var name: String
    var popularity: Double
    var profile_path: String?
    var character: String
    var order: Int

    // Equatable
    static func ==(lhs: MovieCast, rhs: MovieCast) -> Bool {
        return lhs.id == rhs.id &&
            lhs.known_for_department == rhs.known_for_department &&
            lhs.name == rhs.name &&
            lhs.popularity == rhs.popularity &&
            lhs.profile_path == rhs.profile_path &&
            lhs.character == rhs.character &&
            lhs.order == rhs.order
    }
    
}

struct MovieCrew: Codable {
    var name: String
    var profile_path: String?
    var popularity: Double
    var department: String
    var job: String
}


