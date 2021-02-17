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
    @Published var favoriteMovies = [Movie]()
    @Published var watchedMovies = [Movie]()    
    
    lazy private var decoder = JSONDecoder() // used to decode json data
    lazy private var encoder = JSONEncoder()
    
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
    
    
    /// Converting Data to String, then saving to Movie with ID
    func convertMovie(cast json: Data, forMovie movieID: Int) {
        let movie = allMovies.first(where: { $0.uuid == Double(movieID) })
        let castAsString = String(data: json, encoding: .utf8)
        guard let cast = castAsString else { return }
        if let movie = movie {
            movie.cast = cast
            saveContext()
        } else {
            var _ = createNewMovie(uuid: Double(movieID), cast: cast)
        }
    }
    
    /// Update given movie properties
    func update(movie: Movie, uuid: Double? = nil, category: MovieCategory? = nil, director: String? = nil, title: String? = nil, overview: String? = nil, imagePath: String? = nil, genres: String? = nil, cast: String? = nil, releaseDate: String? = nil, rating: Double? = nil, isFavorite: Bool? = nil, isWatched: Bool? = nil, comment: String? = nil) {
        
        if let uuid = uuid {
            movie.uuid = uuid
            print("saved: \(movie.uuid)")
        }
        if let category = category {
            movie.category = category.rawValue
            print("saved: \(movie.category ?? "")")
        }
        if let director = director {
            movie.director = director
            print("saved: \(movie.director ?? "")")
        }
        if let title = title {
            movie.title = title
            print("saved: \(movie.title ?? "")")
        }
        if let overview = overview {
            movie.overview = overview
            print("saved: \(movie.overview ?? "")")
        }
        if let imagePath = imagePath {
            movie.imagePath = imagePath
            print("saved: \(movie.imagePath ?? "")")
        }
        if let genres = genres {
            movie.genres = genres
            print("saved: \(movie.genres ?? "")")
        }
        if let cast = cast {
            movie.cast = cast
            print("saved: \(movie.cast ?? "")")
        }
        if let releaseDate = releaseDate {
            movie.releaseDate = releaseDate
            print("saved: \(movie.releaseDate ?? "")")
        }
        if let rating = rating {
            movie.rating = rating
            print("saved: \(movie.rating)")
        }
        if let isFavorite = isFavorite {
            movie.isFavorite = isFavorite
            print("saved: \(movie.isFavorite)")
        }
        if let isWatched = isWatched {
            movie.isWatched = isWatched
            print("saved: \(movie.isWatched)")
        }
        if let comment = comment {
            movie.comment = comment
            print("saved: \(movie.comment ?? "")")
        }
        if movie.hasChanges {
            saveContext()
        }
    }
    
}

// MARK: Decoding
extension MoviesStore {
    
    func encodeCast(_ cast: [MovieCast]) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(cast) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // Decode Cast JSON from Movie
    func decodeCast(_ movieCast: String) -> [MovieCast]? {
        guard let data = movieCast.data(using: .utf8) else { return nil }
        guard let cast = try? decoder.decode([MovieCast].self, from: data) else { return nil }
        return cast
        
    }
    
    
   /// Encode Array of Genre ID tags to JSON Data as String for saving
    /// Example: FetchGenreIDs -> encode(genres: ) ->  update(movie:, genres: )
    func encodeGenres(_ genres: [Int]) -> String? {
//        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(genres) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func decodeGenres(_ string: String) -> [Int]? {
        guard let data = string.data(using: .utf8) else { return nil }
        guard let ids = try? decoder.decode([Int].self, from: data) else { return nil }
        return ids
        
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
    
    func fetchFavorites() -> [[Movie]]? {
        if favoriteMovies.isEmpty {
            fetchAllFavoriteMovies()
        }
        print("FetchFavorites(): \(favoriteMovies.count)")
        if  favoriteMovies.count == 0 {
            return nil
        }
        var movieArray: [[Movie]] = []
        let dividedCount = favoriteMovies.count / 2
        if dividedCount >= 1 {
            movieArray = favoriteMovies.divided(into: 2)
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

    // Get All Watched Movies
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
        }
        return movieArray
    }
    

    
    func checkIfMovieDetailsNeedToBeFetched(movie: Movie) {
        if movie.cast == nil {
            
        }
        
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
