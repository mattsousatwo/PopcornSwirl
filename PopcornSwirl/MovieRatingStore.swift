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
    var selectedMovieRating = MovieRating()
    
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
//        if context.hasChanges {
            let request: NSFetchRequest<MovieRating> = MovieRating.fetchRequest()
            do {
                let requestResults = try context.fetch(request)
                ratings = requestResults

            } catch {
                print(error)
            }
//        }
        
        print(#function + " ratings count: \(ratings.count)")
    }
    
    // Fetch Rating for Movie
    func fetchRatingsForMovie(id: Int) -> MovieRating? {
        
        for rating in ratings {
            if rating.id != Double(id) { // if id is not in ratings\
                let request : NSFetchRequest<MovieRating> = MovieRating.fetchRequest()
                let idPredicate = NSPredicate(format: "id = %@", id)
                let typePredicate = NSPredicate(format: "type = %@", RatingKeys.movie.rawValue)
                
                let compoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [idPredicate, typePredicate] )
                
                request.predicate = compoundPredicate
                do {
                    let requestResults = try context.fetch(request)
                    if requestResults.count != 0 {
                        for rating in requestResults {
                            print( "rating: \(rating)"  )
                            return rating
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                let newRating = MovieRating(context: context)
                newRating.type = RatingKeys.movie.rawValue
                newRating.id = Double(id)
                self.ratings.append(newRating)
                saveContext()
                print( "rating: \(newRating)"  )
                return newRating
            }
        }
        
        return nil
    }
    
    // Fetch Rating for Movie
    func searchForRatingsFromMovie(id: Int) {
    
        for rating in ratings {
            
            switch rating.id {
            case Double(id): // if id is in ratings
                selectedMovieRating = rating
                print( "rating: \(rating)"  )
            default: // if id is NOT in ratings
                let newRating = MovieRating(context: context)
//
//
                newRating.setValue(RatingKeys.movie.rawValue,
                                   forKey: RatingKeys.type.rawValue)
                newRating.setValue(Double(id),
                                   forKey: RatingKeys.id.rawValue)
                newRating.setValue(false,
                                   forKey: RatingKeys.isFavorite.rawValue)

//                newRating.type = RatingKeys.movie.rawValue
//                newRating.id = Double(id)
//                newRating.isFavorite = false
                self.ratings.append(newRating)
                selectedMovieRating = rating
                saveContext()
                print( "rating: \(rating)"  )
            }
        }
        
    }
    
    
    
}

enum RatingKeys: String {
    case movie = "movie"
    case tv = "tv"
    case actor = "actor"
    case comment = "comment"
    case id = "id"
    case isFavorite = "isFavorite"
    case rating = "rating"
    case type = "type"
}

