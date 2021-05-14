//
//  ActorImages.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - GET ACTOR IMAGES
struct ActorSchema: Codable {
    var id: Int?
    var profiles: [ActorImageProfile]
}

struct ActorImageProfile: Codable {
    var file_path: String?
    var vote_average: Double
}
