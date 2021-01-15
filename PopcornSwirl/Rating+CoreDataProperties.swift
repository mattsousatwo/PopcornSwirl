//
//  MovieRating+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/28/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Rating {
 
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rating> {
        return NSFetchRequest<Rating>(entityName: "Rating")
    }

    @NSManaged public var comment: String?
    @NSManaged public var id: Double 
    @NSManaged public var isFavorite: Bool
    @NSManaged public var rating: Double
    @NSManaged public var type: String?

}

extension Rating : Identifiable {

}
