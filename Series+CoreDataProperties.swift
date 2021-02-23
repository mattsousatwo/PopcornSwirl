//
//  Series+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/23/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Series {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Series> {
        return NSFetchRequest<Series>(entityName: "Series")
    }

    @NSManaged public var cast: String?
    @NSManaged public var overview: String?
    @NSManaged public var rating: Double
    @NSManaged public var uuid: Double
    @NSManaged public var title: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var imagePath: String?

}

extension Series : Identifiable {

}
