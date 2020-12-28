//
//  MovieRating+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieRating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieRating> {
        return NSFetchRequest<MovieRating>(entityName: "MovieRating")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var comment: String?
    @NSManaged public var rating: Double

}

extension MovieRating : Identifiable {

}
