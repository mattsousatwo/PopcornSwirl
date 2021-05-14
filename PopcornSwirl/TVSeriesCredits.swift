//
//  TVSeriesCredits.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

// MARK: - TV Series Credits
struct TVSeriesCreditSchema: Codable {
    var id: Int
    var cast, crew: [TVSeriesCast]
}

struct TVSeriesCast: Codable, Equatable {
    var name: String
    var character: String
    
    static func ==(lhs: TVSeriesCast, rhs: TVSeriesCast) -> Bool {
        return lhs.name == rhs.name &&
            lhs.character == rhs.character
    }
}

