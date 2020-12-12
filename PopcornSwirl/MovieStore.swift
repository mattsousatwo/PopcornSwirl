//
//  TESTMovieDB.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 11/25/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import Alamofire

class MovieStore: ObservableObject {
    
    // Movie Stores
    @Published var popularMovies = [PopMovie]() // all popular movies
    @Published var latestMovies = [LatestMovie]() // all latest movies
    @Published var movieCast = [MovieCast]() // cast for movie
    @Published var recommendedMovies = [RecommendedMovie]() // all recommended movies by movie id
    
    @Published var movieSearchResults = [MovieSearchResults]()
    
    
    lazy var decoder = JSONDecoder() // used to decode json data
    
    lazy var imageURL = "https://image.tmdb.org/t/p/" + "original" // used as base for movie images
        /// Need base_url, file_size and file_path to retrieve images
    
    
    // API Key
    lazy var apiKey = "ebccbee67fef37cc7a99378c44af7d33"
    

    
    // MARK: GET MOVIE CREDITS
    // Get the credits for a movie to fill up the actors view
    func fetchMovieCreditsForMovie(id: Int) {
        
        let creditsRequest = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)&language=en-US"
        
        AF.request( creditsRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let movieCredits = try self.decoder.decode(MovieCredits.self, from: json)
                
                self.movieCast = movieCredits.cast
                print("cast count: \(self.movieCast.count)")
                for x in self.movieCast {
                    print("Actor: \(x)")
                    print(x.name)
                    print("Character: " + x.character)
                    print("Popularity: " + "\(x.popularity)")
                    print("KnownFor: " + x.known_for_department)
                    print("\n")
                }
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
    func fetchActorImages() {
        
    }

    
    // Initalizer
    init() {
        
    }
    
}


// MARK: Movies
extension MovieStore {
    
    // MARK: FETCH Popular Movies
    func fetchPopularMovies() {
        let popMovieRequest = "https://api.themoviedb.org/3/movie/popular?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&page=1"
        
        AF.request( popMovieRequest ).responseJSON {
            response in
            
            guard let json = response.data else { return }
            
            do {
                let decodedMovies = try self.decoder.decode(Popular.self, from: json)
                
                
                self.popularMovies = decodedMovies.results
                for i in 0..<self.popularMovies.count {
                    print("title: \(self.popularMovies[i].title), \n   overview: \(self.popularMovies[i].overview) \n   poster_path: \(self.popularMovies[i].poster_path)")
                }
                
            } catch {
                print(error)
            } // do / catch
            
            
            
        } // request
        
    } // fetchPopularMovies
    
     // MARK: Fetch the Latest Movie - Need to fix to fetch recent movies
    func fetchLatestMovies() {
        let latestRequest = "https://api.themoviedb.org/3/movie/latest?api_key=\(apiKey)&language=en-US"
        
        AF.request( latestRequest ).responseJSON {
            response in
            
            guard let json = response.data else { return }
                        
            do {
                let movie = try self.decoder.decode(LatestMovie.self, from: json)
                self.latestMovies.append(movie)
                
                     print("Latest /n")
                     print("\(self.latestMovies.count)")
                     for i in self.latestMovies {
                         print("title: \(i.title)")
                         print("poster: \(i.poster_path ?? "--")")
                     }
                
            } catch {
                print(error)
            }
            
            
        
        } // request
        
    } // ()
 
    // MARK: Get Reccomended Movies for movie
    func fetchRecommendedMoviesForMovie(id: Int) {
        
        let recommendedRequest = "https://api.themoviedb.org/3/movie/\(id)/recommendations?api_key=\(apiKey)&language=en-US&page=1"
        
        AF.request( recommendedRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let recomendations = try self.decoder.decode(Recommendation.self, from: json)
                
                self.recommendedMovies = recomendations.results
                for x in self.recommendedMovies {
                    print("Movie: \(x.title)")
                    print("Overview: \(x.overview)")
                    print("Poster Path: \(x.poster_path ?? "is empty")")
                    print("\n")
                }
                
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
}


// MARK: Actors
extension MovieStore {
    
    
}


// MARK: Search
extension MovieStore {
    
    // MARK: GET Search Results (MOVIE)
    func fetchResultsForMovie(query: String) {
        
        let searchMovieRequest = "https://api.themoviedb.org/3/search/movie?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&query=\(query)&page=1&include_adult=false"
        
        AF.request( searchMovieRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let searchResults = try self.decoder.decode(MovieSearch.self, from: json)
                
                guard let results = searchResults.results else {
                    print("No movie results found")
                    return }
                
                self.movieSearchResults = results
                
                print("Movie Query Result Count:  \(self.movieSearchResults.count)")
                for movie in self.movieSearchResults {
                    print(movie.title)
                    
                }
                
            } catch {
                print(error)
            }
            
            
        }
        
    }
    
    // MARK: GET Search Results (ACTOR)
    func fetchResultsForActor(query: String) {
        
    }
}


// MARK: POST :: DELETE
extension MovieStore {
    
}
