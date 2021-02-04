//
//  Movie+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/3/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var imagePath: String?
    @NSManaged public var genres: NSObject?
    @NSManaged public var releaseDate: String?
    @NSManaged public var rating: Double
    @NSManaged public var director: String?
    @NSManaged public var uuid: Double
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isWatched: Bool
    @NSManaged public var comment: String?
    @NSManaged public var category: String?
    @NSManaged public var cast: NSObject?
    
}

extension Movie : Identifiable {

}
