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
    
    var entityName = "Rating"
    var context: NSManagedObjectContext
    var entity: NSEntityDescription?
    @Published var ratings: [Rating] = []
    @Published var selectedMovieRating: Rating?
    
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
    
}

// MARK: Create
extension MovieRatingStore {
    
    // Create a new Rating
    func createNewRating(id: Int, isFavorite: Bool = false, type: MovieRatingType = .movie, comment: String = "") -> Rating {
        
        let rating = Rating(context: context)
        
        rating.id = Double(id)
        rating.isFavorite = isFavorite
        
        rating.type = type.rawValue
        
        //        rating.comment = comment
        rating.comment = "Testing Comment"
        
        saveContext()
        
        ratings.append(rating)
        
        print("* movieRating: \(rating)")
        return rating
        
    }
    
}

// MARK: Fetching
extension MovieRatingStore {
    
    // Get all ratings if context hasChanges
    func fetchAllRatings() {
        //        if context.hasChanges {
        let request: NSFetchRequest<Rating> = Rating.fetchRequest()
        do {
            let requestResults = try context.fetch(request)
            ratings = requestResults
            
        } catch {
            print(error)
        }
        //        }
        
        print(#function + " ratings count: \(ratings.count)")
    }
    
    // Search for movie in Ratings
    func searchForRatingsFromMovie(id: Int) -> Rating {
        var rating: Rating
        let ratingIsLoaded = ratings.contains(where: { $0.id == Double(id) })
        print("rating is loaded: \(ratingIsLoaded)")
        switch ratingIsLoaded {
        case true: // Value is in ratings
            rating = ratings.first(where: { $0.id == Double(id) })!
        case false: // Value is not found - search || create
            let d = findMovieRating(id: id)
            rating = d!
        }
        print("SearchForRating -> \(rating)")
        return rating
    }
    
    // fetch for specific rating
    func findMovieRating(id: Int) -> Rating? {
        var rating: Rating?
        
        let request: NSFetchRequest<Rating> = Rating.fetchRequest()
        //        request.predicate = NSPredicate(format: "id = %ld AND type = %@", Double(id), MovieRatingType.movie.rawValue)
        request.predicate = NSPredicate(format: "id = %ld", Double(id))
        do {
            let result = try context.fetch(request)
            ratings.append(contentsOf: result )
            
            if result.count != 0 {
                for result in result {
                    if result.type == MovieRatingType.movie.rawValue &&
                        result.id == Double(id) {
                        rating = result
                    }
                }
            }
        } catch {
            print(error)
        }
        
        if rating == nil {
            rating = createNewRating(id: id)
        }
        
        return rating
    }
    
    
    // Fetch Ratings for an array of movieIDs
    func fetchAllRatingsUsingIDs(in movieIDs: [Int]) -> [Rating] {
        var ratingArray: [Rating] = []
        let request: NSFetchRequest<Rating> = Rating.fetchRequest()
        
        for id in movieIDs {
            request.predicate = NSPredicate(format: "id = %ld", id)
            do {
                let result = try context.fetch(request)
                if result.isEmpty == true {
                    let newRating = createNewRating(id: id)
                    ratingArray.append(newRating)
                } else {
                    ratingArray.append(contentsOf: result)
                }
            } catch {
                print(error)
            }
        }
        return ratingArray
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
    
    case entity = "Rating"
}

enum MovieRatingType: String {
    case movie = "movie"
    case tv = "tv"
    case actor = "actor"
}
