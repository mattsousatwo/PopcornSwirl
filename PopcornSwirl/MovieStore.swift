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
    @Published var externalMovieID = String()
    
    let decoder = JSONDecoder()
    
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
    
    
    // Get ExternalID to search IMDB for actors using externalID
    func fetchExternalIDWithMovie(id: Int) {
        print("movieID" + ": \(id)")
        let externalRequest = "https://api.themoviedb.org/3/movie/\(id)/external_ids?api_key=\(apiKey)"
        
        // Get IMDB ID
        AF.request( externalRequest ).responseJSON {
            response in
            
            guard let json = response.data else { return }
            
            do {
                let externalIDs = try self.decoder.decode(ExternalID.self, from: json)
                
                guard let imdbID = externalIDs.imdb_id else { return }
                self.externalMovieID = imdbID
                print("externalTAG = \(imdbID)")
//                self.fetchActorsForMovie(id: self.externalMovieID)
            } catch {
                print(error)
            }
        }
        
        
    }
    
    
    func fetchActorsForMovie(id: String) {
            
        print("IMDBID" + ": \(id)")
        
        let actorsRequest = "https://api.themoviedb.org/3/find/\(id)?api_key=\(apiKey)&language=en-US&external_source=imdb_id"
        
        AF.request( actorsRequest ).responseJSON {
            response in
            
            guard let json = response.data else { return }
            
            do {
                
                let findResults = try self.decoder.decode(FindResults.self, from: json)
                
                let f = findResults.person_results
                print(#function)
                print("person_results count: " + "\(f.count)")
                
                
            } catch {
                print(error)
            }
            
        }
        
        
    }
    
    
    
    // Initalizer
    init() {
        
    }
    
}
