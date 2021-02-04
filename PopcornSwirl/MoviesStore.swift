//
//  MoviesStore.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/30/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

class MoviesStore: ObservableObject {
    
    var context: NSManagedObjectContext
    var entity: NSEntityDescription
    
    @Published var allMovies = [Movie]()
    @Published var popularMovies = [Movie]()
    @Published var upcomingMovies = [Movie]()
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: MovieKeys.entity.rawValue, in: context)!
    }
    
}

// MARK: SAVING
extension MoviesStore {
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    // Save a new movie
    func createNewMovie(uuid: Double, category: MovieCategory = .none, director: String = "", title: String = "", overview: String = "", genres: [Int] = [], cast: [Int] = [], releaseDate: String = "", rating: Double = 0.0, isFavorite: Bool = false, isWatched: Bool = false, comment: String = "") -> Movie {
        
        let movie = Movie(context: context)
        
        movie.uuid = uuid
        movie.category = category.rawValue
        
        movie.director = director
        movie.title = title
        movie.overview = overview
//        movie.genres = genres ---- CONVERT TO NSOBJECT?
//        movie.cast
        
        movie.releaseDate = releaseDate
        movie.rating = rating
        
        movie.isFavorite = isFavorite
        movie.isWatched = isWatched
        movie.comment = comment
        
        saveContext()
        
        return movie
    }
    
}


// MARK: FETCHING
extension MoviesStore {
    
    // Fetch all movies
    func fetchMovies(in movieCategory: MovieCategory = .none) {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        request.predicate = NSPredicate(format: "category = %@", movieCategory.rawValue)
        
        do {
            let result = try context.fetch(request)
            
            switch movieCategory {
            case .none:
                allMovies.append(contentsOf: result)
            case .popular:
                popularMovies.append(contentsOf: result)
            case .upcoming:
                upcomingMovies.append(contentsOf: result)
            }
            
        } catch {
            print(error)
        }
    }
    
    // Extract all movies
    func extractMovies(_ movieCategory: MovieCategory = .none) -> [Movie] {
        var movies = [Movie]()
        
        switch movieCategory {
        case .none:
            fetchMovies()
            movies.append(contentsOf: allMovies)
        case .popular:
            fetchMovies(in: .popular)
            movies.append(contentsOf: popularMovies)
        case .upcoming:
            fetchMovies(in: .upcoming)
            movies.append(contentsOf: upcomingMovies)
        }
        
        return movies
    }
    
    
    // Fetch an array of Movies with ID
    func fetchMovies(uuids: [Double]) -> [Movie] {
        var movieArray: [Movie] = []
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        for id in uuids {
            request.predicate = NSPredicate(format: "uuid = %ld", id)
            do {
                let result = try context.fetch(request)
                switch result.isEmpty {
                case true:
                    let newMovie = createNewMovie(uuid: id)
                    movieArray.append(newMovie)
                case false:
                    movieArray.append(contentsOf: result)
                }
            } catch {
                print(error)
            }
        }
        return movieArray
    }
    
    // Fetch all favorited movies
    func fetchFavoriteMovies() -> [Movie] {
        var movieArray: [Movie] = []
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == @%", "true")
        do {
            let result = try context.fetch(request)
            movieArray.append(contentsOf: result)
        } catch {
            print(error)
        }
        return movieArray
    }
    
    // Fetch all watched movies
    func fetchWatchedMovies() -> [Movie] {
        var movieArray: [Movie] = []
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "isWatched == @%", "true")
        do {
            let result = try context.fetch(request)
            movieArray.append(contentsOf: result)
        } catch {
            print(error)
        }
        return movieArray
    }
    
    
}

// MARK: DELETING
extension MoviesStore {
    
    func deleteAllMovie() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: MovieKeys.entity.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        saveContext()
    }
    
}

enum MovieKeys: String {
    case entity = "Movie"
}

enum MovieCategory: String {
    case none = "---" // Movie is not in Popular or Upcoming Movies Scroll Bar
    case popular = "Popular"
    case upcoming = "Upcoming"
}
