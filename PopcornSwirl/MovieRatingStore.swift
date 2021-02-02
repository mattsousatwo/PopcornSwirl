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
        
        rating.uuid = Double(id)
        rating.isFavorite = isFavorite
        
        rating.type = type.rawValue
        
        //        rating.comment = comment
        rating.comment = "MovieID: \(id)"
        
        saveContext()
        
        ratings.append(rating)
        
        print(" * NEW MOVIE RATING * : \(rating)")
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
        
//        fetchAllRatings()
        var rating: Rating?
        
        rating = findMovieRating(id: id)
        
        if rating == nil {
            print("SearchForRating: rating is not found")
        } else {
            print("SearchForRating: rating is FOUND")
        }
        
        
        
        guard let unwrappedRating = rating else {
            let newRating = createNewRating(id: id)
            print("SearchForRating: CreatedRating -> \(newRating)")
            return newRating
        }

        print("SearchForRating: unwrappedRating -> \(unwrappedRating)")
        print("searchForRating - ratings count: \(ratings.count)")
        return unwrappedRating
    }
    
    // fetch for specific rating
    func findMovieRating(id: Int) -> Rating? {
        var rating: Rating?
        
        let request: NSFetchRequest<Rating> = Rating.fetchRequest()
//                request.predicate = NSPredicate(format: "id = %ld AND type = %@", Double(id), MovieRatingType.movie.rawValue)
//        request.predicate = NSPredicate(format: "id = %i", id)
        request.predicate = NSPredicate(format: "uuid = %i", id)
//        request.predicate = NSPredicate(format: "id = 1")
        do {
            let result = try context.fetch(request)
            
            if result.count != 0 {
                for result in result {
                    if result.type == MovieRatingType.movie.rawValue &&
                        result.uuid == Double(id) {
                        rating = result
                        
                        ratings.append(result)
                    }
                }
            }
        } catch {
            print(error)
        }
        
        return rating
    }
    
    
    // Fetch Ratings for an array of movieIDs
    func fetchAllRatingsUsingIDs(in movieIDs: [Int]) -> [Rating] {
        var ratingArray: [Rating] = []
        let request: NSFetchRequest<Rating> = Rating.fetchRequest()
        
        for id in movieIDs {
            request.predicate = NSPredicate(format: "uuid = %i", id)
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
