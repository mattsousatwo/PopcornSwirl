//
//  APICodingKeys.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 11/20/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import Alamofire

// Keys for Now Playing
struct NowPlaying: Codable {
    var page: Int
    var results: [Results]
}


struct Results: Codable {
    var poster_path: String
    var adult: Bool
    var overview: String
    var release_date: String
//    var genre_ids: [GenreIDs]
    var id: Int
    var original_title: String
    var original_language: String
    var title: String
    var backdrop_path: String
    var popularity: Double
    var vote_count: Double 
    var video: Bool
    var vote_average: Double
}


// Keys for Popular movies
struct Popular: Codable {
    public var page: Int
    public var results: [PopMovie]
}

struct PopularMovie: Codable {
    var poster_path: String
    var adult: Bool
    var overview: String
    var release_date: String
//    var genre_ids
    var original_title: String
    var original_language: String
    var title: String
    var backdrop_path: String
    var popularity: Double
    var vote_count: Int
    var video: Bool
    var vote_average: Double
}




struct PopMovie: Codable, Identifiable {
    public var id: Int
    public var title: String
    public var overview: String
}





// Class to handle fetching Movie data 
class MovieManager {
    
    var decoder = JSONDecoder()
    lazy var APIKey = "ebccbee67fef37cc7a99378c44af7d33"
    
    @Published var popularMovies: [PopularMovie] = []
        
    // Get most popular movies from DB
    func getPopularMovies() -> [PopularMovie] {
        
        let popularMovieRequest = "https://api.themoviedb.org/3/movie/popular?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&page=1"
        var popMovies: [PopularMovie] = []
         
        AF.request( popularMovieRequest ).responseJSON { response in
           
           if let x = response.data {
               do {
                
                let xData = try self.decoder.decode(Popular.self, from: x)
                   
                   print("\(xData.page)" + " xData")
                   
                   guard let overview = xData.results.first?.overview else { return }
                   guard let title = xData.results.first?.title else { return }
                   
 //                   popMovies = xData.results
                   print("Title: " + title + "\n" + "Overview: " + overview + "PopularMovieRequest 1")
                   print("Count: \(xData.results.count)")
                
//                self.popularMovies = xData.results
                   
               } catch {
                   print(error)
               }
           }
           
       }
        
        return popMovies
        
        
    }
    
    func getPublishedPopMovies()  {
        let popularMovieRequest = "https://api.themoviedb.org/3/movie/popular?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&page=1"
         
        AF.request( popularMovieRequest ).responseJSON { response in
           
           if let x = response.data {
               do {
                DispatchQueue.global().async {
                    self.popularMovies = self.parseJSON(data: x)
                    
                   
                    guard let overview = self.popularMovies.first?.overview else { return }
                    guard let title = self.popularMovies.first?.title else { return }
                   
                
                    print("Title: " + title + "\n" + "Overview: " + overview + "PopularMovieRequest 1")
                    print("Count: \(self.popularMovies.count)")
                    }
                
               }
            
           }
           
       }
        
        
        
    } 
    
    func parseJSON(data: Data) -> [PopularMovie] {
        do {
            let movieStore = try self.decoder.decode(Popular.self, from: data)
      //      self.popularMovies = movieStore.results
        } catch {
            print(error)
        }
        return popularMovies
        
    }
    
    
    
}

