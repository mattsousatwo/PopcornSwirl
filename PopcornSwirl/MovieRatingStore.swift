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

class MovieRatingStore : ObservableObject {
    
    var entityName = "MovieRating"
    var context: NSManagedObjectContext
    var entity: NSEntityDescription?
    @Published var ratings: [MovieRating] = []
    @Published var selectedMovieRating: MovieRating?
    
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
                // MARK: Throws Errors if rating.id == id
                    // Will work if set to 0 (default number for id)
                    // Error: if id == IDNotAssignedToRating
                
// MARK: -      Predicates = [ID, type]
                let idPredicate = NSPredicate(format: "id = %ld", id)
                let typePredicate = NSPredicate(format: "type = %@", MovieRatingType.movie.rawValue)
                let compoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [idPredicate, typePredicate] )
                print("fetchRatingsForMovie(\(id))")
                request.predicate = compoundPredicate
// MARK: -
                
                
                // Predicate = AND - ID, type
//                request.predicate = NSPredicate(format: "id == %@ AND type == %@", Double(id), RatingKeys.movie.rawValue)
                
                // Predicate = type
//                request.predicate = NSPredicate(format: "type = %@", RatingKeys.movie.rawValue)
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
            } else { // if ID is in ratings array 
                let newRating = MovieRating(context: context)
                newRating.type = MovieRatingType.movie.rawValue
                newRating.id = Double(id)
                self.ratings.append(newRating)
                saveContext()
                print( "rating: \(newRating)"  )
                return newRating
            }
            
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
    // Search for movie in Ratings
    func searchForRatingsFromMovie(id: Int) -> MovieRating {
        
        var rating : MovieRating
        let ratingIsLoaded = ratings.contains(where: { $0.id == Double(id) })
        
        if ratingIsLoaded == false {
            let request: NSFetchRequest<MovieRating> = MovieRating.fetchRequest()
            request.predicate = NSPredicate(format: "id = %ld", Double(id) )
            do {
                let result = try context.fetch(request)
                ratings.append(contentsOf: result )
            } catch {
                print(error)
            }

            
        }
        
        
        
        switch ratingIsLoaded {
        case true : // Value is in ratings - return
            rating = ratings.first(where: {$0.id == Double(id) })!
        case false : // Value is not in ratings - create
            rating =  createNewRating(id: id)
        }

        return rating
        
    }
    
    // Create a new Rating
    func createNewRating(id: Int, isFavorite: Bool = false, type: MovieRatingType = .movie, comment: String = "") -> MovieRating {
    
        let rating = MovieRating(context: context)
        
        rating.id = Double(id)
        rating.isFavorite = isFavorite
        
        var ratingType = ""
        switch type {
        case .actor:
            ratingType = MovieRatingType.actor.rawValue
        case .movie:
            ratingType = MovieRatingType.movie.rawValue
        case .tv:
            ratingType = MovieRatingType.tv.rawValue
        }
        rating.type = ratingType
        
        rating.comment = comment
        
        saveContext()
        
        ratings.append(rating)
        
        print("* movieRating: \(rating)")
        return rating
        
    }
    
    func toggleFavorite(for object: MovieRating) {
        object.isFavorite.toggle()
        saveContext()
    }
    
    
    
}

// MARK: Delete
extension MovieRatingStore {
    
    // Delete All
    func deleteAllMovieRatings() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: RatingKeys.entity.rawValue)
//        request.predicate = NSPredicate(format: "goal_UID = %@", tag)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        saveContext()
        
    }
}

enum RatingKeys: String {
    case type = "type"

    case comment = "comment"
    case id = "id"
    case isFavorite = "isFavorite"
    case rating = "rating"
    
    case entity = "MovieRating"
}

enum MovieRatingType: String {
    case movie = "movie"
    case tv = "tv"
    case actor = "actor"
}
