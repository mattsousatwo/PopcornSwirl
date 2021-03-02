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
    func createNewMovie(uuid: Double, category: MovieCategory = .none, director: String = "", title: String = "", overview: String = "", genres: [Int] = [], cast: String = "", releaseDate: String = "", rating: Double = 0.0, isFavorite: Bool = false, isWatched: Bool = false, comment: String = "") -> Movie {
        
        let movie = Movie(context: context)
        
        movie.uuid = uuid
        movie.category = category.rawValue
        
        movie.director = director
        movie.title = title
        movie.overview = overview
//        movie.genres = genres ---- CONVERT TO NSOBJECT?
//        if cast != "" {
//            movie.cast = cast
//        }
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
            print("saved uuid: \(movie.uuid)")
        }
        if let category = category {
            movie.category = category.rawValue
            print("saved category: \(movie.category ?? "is Empty")")
        }
        if let director = director {
            movie.director = director
            print("saved director: \(movie.director ?? "is Empty")")
        }
        if let title = title {
            movie.title = title
            print("saved title: \(movie.title ?? "is Empty")")
        }
        if let overview = overview {
            movie.overview = overview
            print("saved overview: \(movie.overview ?? "is Empty")")
        }
        if let imagePath = imagePath {
            movie.imagePath = imagePath
            print("saved imagePath: \(movie.imagePath ?? "is Empty")")
        }
        if let genres = genres {
            movie.genres = genres
            print("saved genres: \(movie.genres ?? "is Empty")")
        }
        if let cast = cast {
            movie.cast = cast
            print("saved cast: \(movie.cast ?? "is Empty")")
        }
        if let releaseDate = releaseDate {
            movie.releaseDate = releaseDate
            print("saved releaseDate: \(movie.releaseDate ?? "is Empty")")
        }
        if let rating = rating {
            movie.rating = rating
            print("saved rating: \(movie.rating)")
        }
        if let isFavorite = isFavorite {
//            movie.isFavorite = isFavorite
            movie.isFavorite = NSNumber(value: isFavorite) as! Bool
            print("saved isFavorite: \(movie.isFavorite)")
        }
        if let isWatched = isWatched {
            movie.isWatched = NSNumber(value: isWatched) as! Bool
            print("saved isWatched: \(movie.isWatched)")
        }
        if let comment = comment {
            movie.comment = comment
            print("saved comment: \(movie.comment ?? "is Empty")")
        }
        if let recomendedMovies = recommendedMovies {
            movie.recommendedMovies = recomendedMovies
            print("saved recommendedMovies: \(movie.recommendedMovies ?? "is Empty")")
        }
        if let voteAverage = voteAverage {
            movie.voteAverage = voteAverage
            print("saved voteAverage: \(movie.voteAverage)")
        }
        if let watchProviders = watchProviders {
            movie.watchProviders = watchProviders
            print("saved watchProviders: \(movie.watchProviders ?? "is Empty")")
        }
        
        if movie.hasChanges {
            saveContext()
        }
    }
    
    
    func fetchAndUpdatePopularMovie() {
        
    }
    
    /// Update properties for Movie using properties from a PopMovie
    func updatePropertiesFor(movie: Movie, with popMovie: PopMovie) {
        
        
        if movie.title == nil {
            update(movie: movie, title: popMovie.title)
        }
        if movie.overview == nil {
            update(movie: movie, overview: popMovie.overview)
        }
        if movie.imagePath == nil {
            update(movie: movie, imagePath: popMovie.poster_path)
        }
        if movie.genres == nil {
            if let genres = encodeGenres(popMovie.genre_ids) {
                update(movie: movie, genres: genres)
            }
        }
        if movie.releaseDate == nil {
            update(movie: movie, releaseDate: popMovie.release_date)
        }
        if movie.voteAverage == 0 {
            update(movie: movie, voteAverage: popMovie.vote_average)
        }
        
        
        var movieIsPopular: Bool = false
        var movieStore = MovieStore()
        print("MovieIsPopular - movieCount: \(movieStore.popularMovies.count)")
        for fetchedPopularMovie in movieStore.popularMovies {
            if Int(movie.uuid) == fetchedPopularMovie.id {
                movieIsPopular = true
            } else {
                movieIsPopular = false
            }
        }
        
            switch movieIsPopular {
            case true:
                update(movie: movie, category: .popular)
                print("MovieIsPopular: \(movieIsPopular)")
            case false:
                update(movie: movie, category: nil)
                print("MovieIsPopular: \(movieIsPopular)")
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
    
    // Extract all movies
    func extractMovies(_ movieCategory: MovieCategory = .none) -> [Movie] {
        var movies = [Movie]()
        
        switch movieCategory {
        case .none:
            fetchMovies()
            movies.append(contentsOf: allMovies)
        case .popular:
            fetchMovies(.popular)
            movies.append(contentsOf: popularMovies)
        case .upcoming:
            fetchMovies( .upcoming)
            movies.append(contentsOf: upcomingMovies)
        }
        
        return movies
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
                    print("Movie Not Found \(id)")
                    let newMovie = createNewMovie(uuid: id)
                    movieArray.append(newMovie)
                    print(" -> Movie Saved: \(newMovie.uuid) \n")
                case false:
                    print("Movie Found: \(id)")
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
                print("Movie Not Found \(uuid)")
                let newMovie = createNewMovie(uuid: Double(uuid))
                movie = newMovie
            case false:
                
                for element in result {
                    print("Movie Found: \(element.title ?? "no title"), id: \(id)")
                    movie = element
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
        print("FetchFavorites(): \(favoriteMovies.count)")
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
        print("FetchWatched(): \(watchedMovies.count)")
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

// Used to define if any properties are missing from Movie entiy - if so, fetch from TMDB
enum MissingProperties {
    case title
    case overview
    case director
    case releaseDate
    case image
    case cast
    case genres
    case reccomendedMovies
}
