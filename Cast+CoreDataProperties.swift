//
//  Cast+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/31/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Cast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cast> {
        return NSFetchRequest<Cast>(entityName: "Cast")
    }

    @NSManaged public var actorID: Double
    @NSManaged public var movieID: Double

}

extension Cast : Identifiable {

}
