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
    
    lazy private var decoder = JSONDecoder() // used to decode json data
    
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
    func update(movie: Movie, uuid: Double? = nil, category: MovieCategory? = nil, director: String? = nil, title: String? = nil, overview: String? = nil, genres: [Int]? = nil, cast: String? = nil, releaseDate: String? = nil, rating: Double? = nil, isFavorite: Bool? = nil, isWatched: Bool? = nil, comment: String? = nil) {
        
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
//        if let genres = genres {
//            movie.genres = genres
//        }
//        if let cast = cast {
//            movie.cast = cast
//        }
        if let releaseDate = releaseDate {
            movie.releaseDate = releaseDate
        }
        if let rating = rating {
            movie.rating = rating
        }
        if let isFavorite = isFavorite {
            movie.isFavorite = isFavorite
        }
        if let isWatched = isWatched {
            movie.isWatched = isWatched
        }
        if let comment = comment {
            movie.comment = comment
        }
        saveContext()
    }
    
    
    
}

// MARK: Decoding
extension MoviesStore {
    
    // Decode Cast JSON from Movie
    func decodeCast(from movie: Movie) {
        
    }
    
    func encode(cast: MovieCast) {
        
    }
    
    
   /// Encode Array of Genre ID tags to JSON Data as String for saving
    /// Example: FetchGenreIDs -> encode(genres: ) ->  update(movie:, genres: )
    func encodeGenres(_ genres: [Int]) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(genres) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func decodeGenres(_ string: String) -> [Int]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(string) else { return nil }
        guard let ids = try? decoder.decode([Int].self, from: data) else { return nil }
        return ids
    }
    
}


// MARK: FETCHING
extension MoviesStore {
    
    // Fetch all movies
    func fetchMovies(in movieCategory: MovieCategory = .none) {
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
