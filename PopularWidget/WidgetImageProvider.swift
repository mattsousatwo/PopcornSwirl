//
//  WidgetImageProvider.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

enum WidgetImageResponse {
    case Success(reference: [PopularReference])
    case Failure
}

class WidgetImageProvider {
    
    static func getImageFromApi(completion: ((WidgetImageResponse) -> Void)?) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&page=1")!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            parseResponseAndGetImage(data: data, urlResponse: urlResponse, error: error, completion: completion)
        }
        task.resume()
    }
    
    static func parseResponseAndGetImage(data: Data?, urlResponse: URLResponse?, error: Error?, completion: ((WidgetImageResponse) -> Void)? ) {
        
        guard error == nil, let content = data else {
            print("Error getting data from API")
            let response = WidgetImageResponse.Failure
            completion?(response)
            return
        }
        
        var apiResponse: Popular
        do {
            apiResponse = try JSONDecoder().decode(Popular.self, from: content)
        } catch {
            print("Error parsing URL from data")
            let response = WidgetImageResponse.Failure
            completion?(response)
            return
        }
        
        
        if let firstMovie = apiResponse.results.first {
            
            
            let url = ("https://image.tmdb.org/t/p/original" + firstMovie.poster_path)
            let urlRequest = URLRequest(url: URL(string: url)!)
            let task = URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
                parseImageFromResponse(data: data, urlResponse: urlResponse, error: error, title: firstMovie.title, description: firstMovie.overview, completion: completion)
            }
            task.resume()
        }
    }
    
    static func parseImageFromResponse(data: Data?, urlResponse: URLResponse?, error: Error?, title: String, description: String, completion: ((WidgetImageResponse) -> Void)?) {
        
        guard error == nil, let content = data else {
            print("Error getting image data")
            let response = WidgetImageResponse.Failure
            completion?(response)
            return
        }
        
        let image = UIImage(data: content)!
        let reference = PopularReference(poster: image, title: title, description: description)
        let response = WidgetImageResponse.Success(reference: [reference])
        completion?(response)
    }
}




