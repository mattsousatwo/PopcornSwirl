//
//  TESTMovieDB.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 11/25/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import Alamofire

class Observer: ObservableObject {
    
    @Published var movies = [PopMovie]()
    let decoder = JSONDecoder()
    
    
    func getMoivies() {
        
        let movieRequest = "https://api.themoviedb.org/3/movie/popular?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&page=1"
        
        AF.request(movieRequest).responseJSON {
            response in
            
            if let json = response.value {
                
                if (json as? [String: AnyObject]) != nil {
                    print("1")
                    if let dictionaryArray = json as? Dictionary<String, AnyObject?> {
                        let jsonArray = dictionaryArray["value"]
                        print("2")
                        if let jsonArray = jsonArray as? Array<Dictionary<String, AnyObject>>{
                            print("3")
                            for i in 0..<jsonArray.count{
                                let json = jsonArray[i]
                                if let id = json["id"] as? Int,
                                   let title = json["title"] as? String,
                                   let overview = json["overview"] as? String {
                                    self.movies.append(PopMovie(id: id, title: title, overview: overview)) 
                                    print("Title: \(self.movies[i].title), \n   Overview: \(self.movies[i].overview)")
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
        } // AF.request
        
        
    }
    
    func getMovies2() {
        let popularMovieRequest = "https://api.themoviedb.org/3/movie/popular?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&page=1"
        
        AF.request( popularMovieRequest ).responseJSON {
            response in
            
            guard let json = response.data else { return }
            
            do {
                let decodedMovies = try self.decoder.decode(Popular.self, from: json)
                print("\(decodedMovies.results)")
                
                self.movies = decodedMovies.results
                
            } catch {
                print(error)
            }
            
            
            
        }
        
    }
    
    
    init() {
        getMovies2()
    }
    
    
}
