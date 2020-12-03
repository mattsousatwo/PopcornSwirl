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
                print("\(decodedMovies.results)")
                
                self.popularMovies = decodedMovies.results
                for i in 0..<self.popularMovies.count {
                    print("title: \(self.popularMovies[i].title), \n   overview: \(self.popularMovies[i].overview) \n ")
                }
                
            } catch {
                print(error)
            } // do / catch
            
            
            
        } // request
        
    } // fetchPopularMovies
    
    
    // Fetch all the latest movies
    func fetchLatestMovies() {
        let latestRequest = "https://api.themoviedb.org/3/movie/latest?api_key=\(apiKey)&language=en-US"
        
        AF.request( latestRequest ).responseJSON {
            response in
            
            guard let json = response.data else { return }
            
            do {
                let decodedMovie = try self.decoder.decode(Latest2.self, from: json)
                self.latestMovies.append(decodedMovie)
                
                     print("Latest /n")
                print("\(self.latestMovies.count)")
                     for i in self.popularMovies {
                         print("title: \(i.title)")
                     }
                
            } catch {
                print(error)
            }
        
        } // request
        
    } // ()
    
    
    // Initalizer
    init() {
        fetchPopularMovies()
        fetchLatestMovies()
        
    }
    
    
}
