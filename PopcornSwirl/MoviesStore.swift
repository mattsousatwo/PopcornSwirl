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

class MoviesStore: CoreDataCoder, ObservableObject {
    
    var context: NSManagedObjectContext
    var entity: NSEntityDescription
    
    @Published var allMovies = [Movie]()
    @Published var popularMovies = [Movie]()
    @Published var upcomingMovies = [Movie]()
    @Published var favoriteMovies = [Movie]()
    @Published var watchedMovies = [Movie]()
    

    override init() {
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
    func createNewMovie(uuid: Double, category: MovieCategory = .none, director: String = "", title: String = "", overview: String = "", genres: String = "", cast: String = "", releaseDate: String = "", rating: Double = 0.0, isFavorite: Bool = false, isWatched: Bool = false, comment: String = "") -> Movie {
        
        let movie = Movie(context: context)
        
        movie.uuid = uuid
        movie.category = category.rawValue
        movie.director = director
        movie.title = title
        movie.overview = overview
        movie.genres = genres
        movie.releaseDate = releaseDate
        movie.rating = rating
        
        movie.isFavorite = isFavorite
        movie.isWatched = isWatched
        movie.comment = comment
        
        saveContext()
        return movie
    }

    /// Update given movie properties
    func update(movie: Movie,
                uuid: Double? = nil,
                category: MovieCategory? = nil,
                director: String? = nil,
                title: String? = nil,
                overview: String? = nil,
                imagePath: String? = nil,
                genres: String? = nil,
                cast: String? = nil,
                releaseDate: String? = nil,
                rating: Double? = nil,
                isFavorite: Bool? = nil,
                isWatched: Bool? = nil,
                comment: String? = nil,
                recommendedMovies: String? = nil,
                voteAverage: Double? = nil,
                watchProviders: String? = nil) {
        
        if let uuid = uuid {
            movie.uuid = uuid
        }
        if let category = category {
            movie.category = category.rawValue
        }
        if let director = director {
            movie.director = director
        }
        if let title = title {
            movie.title = title
        }
        if let overview = overview {
            movie.overview = overview
        }
        if let imagePath = imagePath {
            movie.imagePath = imagePath
        }
        if let genres = genres {
            movie.genres = genres
        }
        if let cast = cast {
            movie.cast = cast
        }
        if let releaseDate = releaseDate {
            movie.releaseDate = releaseDate
        }
        if let rating = rating {
            movie.rating = rating
        }
        if let isFavorite = isFavorite {
            movie.isFavorite = NSNumber(value: isFavorite) as! Bool
        }
        if let isWatched = isWatched {
            movie.isWatched = NSNumber(value: isWatched) as! Bool
        }
        if let comment = comment {
            movie.comment = comment
        }
        if let recomendedMovies = recommendedMovies {
            movie.recommendedMovies = recomendedMovies
        }
        if let voteAverage = voteAverage {
            movie.voteAverage = voteAverage
        }
        if let watchProviders = watchProviders {
            movie.watchProviders = watchProviders
        }
        
        if movie.hasChanges {
            saveContext()
        }
    }

}

// MARK: FETCHING
extension MoviesStore {
    
    // Fetch all movies
    func fetchMovies(_ movieCategory: MovieCategory = .none) {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        switch movieCategory {
        case .none:
            break
        default:
            request.predicate = NSPredicate(format: "category = %@", movieCategory.rawValue)
        }
        
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
    
    // Fetch an array of Movies with ID
    func fetchMovies(uuids: [Double]) -> [Movie] {
        var movieArray: [Movie] = []
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        for id in uuids {
            request.predicate = NSPredicate(format: "uuid == %i", Int(id))
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
    
    // Fetch a Movie with ID
    func fetchMovie(uuid: Int) -> Movie {
        var movie = Movie()
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let id = Int(uuid)
        request.predicate = NSPredicate(format: "uuid == %i", id)
        do {
            let result = try context.fetch(request)
            switch result.isEmpty {
            case true:
                let newMovie = createNewMovie(uuid: Double(uuid))
                movie = newMovie
            case false:
                
                if let movieElement = result.first {
                    movie = movieElement
                }
            }
        } catch {
            print(error)
        }
        
        return movie
    }
    
    // Fetch all favorited movies
    func getAllFavoriteMovies() -> [Movie] {
        var movieArray: [Movie] = []
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        do {
            let result = try context.fetch(request)
            movieArray.append(contentsOf: result)
        } catch {
            print(error)
        }
        return movieArray
    }
    
    // Used to fetch all movies and store them into a local array
    func fetchAllFavoriteMovies() {
        if favoriteMovies.isEmpty == true {
            let favorites = getAllFavoriteMovies()
            favoriteMovies.append(contentsOf: favorites)
        }
    }
    
    // Used in SavedMovies
    func fetchFavorites() -> [[Movie]]? {
        if favoriteMovies.isEmpty {
            fetchAllFavoriteMovies()
        }
        if favoriteMovies.count == 0 {
            return nil
        }
        var movieArray: [[Movie]] = []
        let dividedCount = favoriteMovies.count / 2
        if dividedCount >= 1 {
            movieArray = favoriteMovies.divided(into: 2)
        } else {
            movieArray = [favoriteMovies]
        }
        if movieArray.count == 0 {
            return nil
        }
        return movieArray
    }
    
    // Fetch all watched movies
    func getAllWatchedMovies() -> [Movie] {
        var movieArray: [Movie] = []
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.predicate = NSPredicate(format: "isWatched == %@", NSNumber(value: true))
        do {
            let result = try context.fetch(request)
            movieArray.append(contentsOf: result)
        } catch {
            print(error)
        }
        return movieArray
    }
    
    // Used to fetch all movies and store them into a local array
    func fetchAllWatchedMovies() {
        if watchedMovies.isEmpty == true {
            let watched = getAllWatchedMovies()
            watchedMovies.append(contentsOf: watched)
        }
    }
    
    // Get All Watched Movies - used in SavedMovies
    func fetchWatched() -> [[Movie]]? {
        if watchedMovies.isEmpty {
            fetchAllWatchedMovies()
        }
        if watchedMovies.count == 0 {
            return nil
        }
        var movieArray: [[Movie]] = []
        let dividedCount = watchedMovies.count / 2
        if dividedCount >= 1 {
            movieArray = watchedMovies.divided(into: 2)
        } else {
            movieArray = [watchedMovies]
        }
        if movieArray.count == 0 {
            return nil
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

