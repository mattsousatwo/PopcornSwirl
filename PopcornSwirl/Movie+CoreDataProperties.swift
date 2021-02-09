//
//  Movie+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/8/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var category: String?
    @NSManaged public var comment: String?
    @NSManaged public var director: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isWatched: Bool
    @NSManaged public var overview: String?
    @NSManaged public var rating: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var uuid: Double
    
    @NSManaged public var cast: String?
    @NSManaged public var genres: String?

}

extension Movie : Identifiable {

}
