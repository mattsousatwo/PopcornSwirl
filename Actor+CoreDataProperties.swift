//
//  Actor+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/30/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Actor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Actor> {
        return NSFetchRequest<Actor>(entityName: "Actor")
    }

    @NSManaged public var id: Double
    @NSManaged public var name: String?
    @NSManaged public var biography: String?
    @NSManaged public var image: Data?

}

extension Actor : Identifiable {

}
