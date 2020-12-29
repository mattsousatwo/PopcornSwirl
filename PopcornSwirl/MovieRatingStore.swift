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
        
        print(#function + " ratings count: \(ratings.count)")
    }
    
    // Fetch Rating for Movie
    func fetchRatingsForMovie(id: Int) -> MovieRating? {
        
        for rating in ratings {
            if rating.id != Double(id) { // if id is not in ratings\
                let request : NSFetchRequest<MovieRating> = MovieRating.fetchRequest()
                let idPredicate = NSPredicate(format: "id = %@", id)
                let typePredicate = NSPredicate(format: "type = %@", MovieRatingKey.movie.rawValue)
                
                let compoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [idPredicate, typePredicate] )
                
                request.predicate = compoundPredicate
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
                let newRating = MovieRating(context: context)
                newRating.type = MovieRatingKey.movie.rawValue
                newRating.id = Double(id)
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

