//
//  PopularWidgetManager.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftUI

class PopularReference: Equatable {
    static func == (lhs: PopularReference, rhs: PopularReference) -> Bool {
        return lhs.poster == rhs.poster &&
            lhs.description == rhs.description &&
            lhs.title == rhs.title
        
    }
    
    var poster: UIImage
    var title: String
    var description: String
    
    init(poster: UIImage = UIImage(named: "placeholder")!, title: String = "", description: String = "") {
        self.poster = poster
        self.title = title
        self.description = description
    }

}

//class PopularWidgetManager: ObservableObject {
//    
//    lazy var decoder = JSONDecoder()
//    
//    @Published var mostPopularMovie = [PopularReference]()
//    @Published var topMostPopularMovies = [PopularReference]()
//    
//    
//    // Fetch Most Popular Movie
//    // Use Coredata if avalible
//    func fetchMostPopularMovie() {
//        let popMovieRequest = "https://api.themoviedb.org/3/movie/popular?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&page=1"
//        
//        AF.request( popMovieRequest ).responseJSON { response in
//            guard let json = response.data else { return }
//            do {
//                let decodedMovies = try self.decoder.decode(Popular.self, from: json)
//            
//                let allMovies = decodedMovies.results
//                
//                if allMovies.count != 0 {
//                    if let firstMovie = allMovies.first {
//                        let topMovie = PopularReference(poster: firstMovie.poster_path,
//                                                        title: firstMovie.title,
//                                                        description: firstMovie.overview)
//                        self.mostPopularMovie.append(topMovie)
//                    }
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    
//    func extractTopMovie() -> PopularReference {
//        var reference = PopularReference()
//        
//        if mostPopularMovie.count == 0 {
//            fetchMostPopularMovie()
//        }
//        if let topMovie = mostPopularMovie.first {
//            reference = topMovie
//        }
//        return reference
//    }
//    
//    
//    // Fetch top 4 Most Popular Movies
//    // Use Coredata if avalible
//    func fetchTopMostPopularMovies() {
//        
//    }
//    
//}
