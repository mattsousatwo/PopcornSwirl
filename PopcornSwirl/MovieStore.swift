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
    @Published var latestMovies = [Latest2]() // all latest movies
    @Published var movieCast = [MovieCast]() // cast for movie
    
    lazy var decoder = JSONDecoder()
    
    // API Key
    public var apiKey = "ebccbee67fef37cc7a99378c44af7d33"
    
    // Fetch all popular movies
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
    
    
    // Need base_url, file_size and file_path to retrieve images
    
    lazy var baseImageURL = "https://image.tmdb.org/t/p/"
    // base + size + path = image

    
    func fetchPopularMoviePosters() {
        
        var posterPaths: [String] = []
        
        for movie in self.popularMovies {
            
            posterPaths.append(movie.poster_path)
            
        }
        
        if posterPaths.count != 0 {
            for poster in posterPaths {
                AF.request( baseImageURL + "h100" + poster).response {
                    response in
                    
                    guard let fetchedPoster = response.data else { return }
                    
                }
                
            }
        }
    }
    
    
    // Fetch all the latest movie ----- MARK: GETS LATEST MOVIE not movieS
    func fetchLatestMovies() {
        let latestRequest = "https://api.themoviedb.org/3/movie/latest?api_key=\(apiKey)&language=en-US"
        
        AF.request( latestRequest ).responseJSON {
            response in
            
            guard let json = response.data else { return }
                        
            do {
               let movie = try self.decoder.decode(Latest2.self, from: json)
                self.latestMovies.append(movie)
                
                     print("Latest /n")
                    print("\(self.latestMovies.count)")
                     for i in self.latestMovies {
                         print("title: \(i.title)")
                     }
                
            } catch {
                print(error)
            }
            
            
        
        } // request
        
    } // ()
    
    
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
                    print(x.name)
                }
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
    
    
    // Initalizer
    init() {
        
    }
    
}
