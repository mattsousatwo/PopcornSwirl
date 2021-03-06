//
//  Actor+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/24/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Actor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Actor> {
        return NSFetchRequest<Actor>(entityName: "Actor")
    }

    @NSManaged public var biography: String?
    @NSManaged public var id: Double
    @NSManaged public var imagePath: String?
    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var deathDate: String?
    @NSManaged public var birthDate: String?
    @NSManaged public var birthPlace: String?
    @NSManaged public var credits: String?

}

extension Actor : Identifiable {

}
