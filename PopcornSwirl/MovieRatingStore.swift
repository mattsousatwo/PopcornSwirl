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
    
    // Fetch Rating for Movie
    func fetchRatingsForMovie(id: Int) -> MovieRating? {
        
        for rating in ratings {
            if rating.id != id { // if id is not in ratings\
                let request : NSFetchRequest<MovieRating> = MovieRating.fetchRequest()
                request.predicate = NSPredicate(format: "id = %@", id)
                request.predicate = NSPredicate(format: "type = %@", MovieRatingKey.movie.rawValue)
                do {
                    let requestResults = try context.fetch(request)
                    if requestResults.count != 0 {
                        for rating in requestResults {
                            return rating
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                let newRating = MovieRating()
                newRating.type = MovieRatingKey.movie.rawValue
                newRating.id = id
                self.ratings.append(newRating)
                saveContext()
                return newRating
            }
        }
        
        return nil
    }
    
    
    
}

enum MovieRatingKey: String {
    case movie = "movie"
    case tv = "tv"
    case actor = "actor"
}

