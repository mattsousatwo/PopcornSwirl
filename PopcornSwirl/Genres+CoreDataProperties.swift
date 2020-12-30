//
//  Genres+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/29/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData


extension Genres {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genres> {
        return NSFetchRequest<Genres>(entityName: "Genres")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}

extension Genres : Identifiable {

}
