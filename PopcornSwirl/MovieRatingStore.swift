//
//  MovieRating.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MovieRatingStore {
    
    var entityName = "MovieRating"
    var context: NSManagedObjectContext
    var entity: NSEntityDescription?
    var ratings: [MovieRating] = []
    
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
    
    // Save
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    // Get all ratings if context hasChanges
    func fetchAllRatings() {
        if context.hasChanges {
            let request: NSFetchRequest<MovieRating> = MovieRating.fetchRequest()
            do {
                let requestResults = try context.fetch(request)
                ratings = requestResults
            } catch {
                print(error)
            }
        }
    }
    
    
    
    
}

