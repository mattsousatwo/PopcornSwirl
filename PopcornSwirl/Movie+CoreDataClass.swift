//
//  Movie+CoreDataClass.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/8/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    let movieStore = MoviesStore()
    
    func update(uuid: Double? = nil,
                category: MovieCategory? = nil,
                director: String? = nil,
                title: String? = nil,
                overview: String? = nil,
                imagePath: String? = nil,
                genres: String? = nil,
                cast: String? = nil,
                releaseDate: String? = nil,
                rating: Double? = nil,
                isFavorite: Bool? = nil,
                isWatched: Bool? = nil,
                comment: String? = nil,
                recommendedMovies: String? = nil,
                voteAverage: Double? = nil,
                watchProviders: String? = nil) {
        
        if let uuid = uuid {
            self.uuid = uuid
            print("saved uuid: \(self.uuid)")
        }
        if let category = category {
            self.category = category.rawValue
            print("saved category: \(self.category ?? "is Empty")")
        }
        if let director = director {
            self.director = director
            print("saved director: \(self.director ?? "is Empty")")
        }
        if let title = title {
            self.title = title
            print("saved title: \(self.title ?? "is Empty")")
        }
        if let overview = overview {
            self.overview = overview
            print("saved overview: \(self.overview ?? "is Empty")")
        }
        if let imagePath = imagePath {
            self.imagePath = imagePath
            print("saved imagePath: \(self.imagePath ?? "is Empty")")
        }
        if let genres = genres {
            self.genres = genres
            print("saved genres: \(self.genres ?? "is Empty")")
        }
        if let cast = cast {
            self.cast = cast
            print("saved cast: \(self.cast ?? "is Empty")")
        }
        if let releaseDate = releaseDate {
            self.releaseDate = releaseDate
            print("saved releaseDate: \(self.releaseDate ?? "is Empty")")
        }
        if let rating = rating {
            self.rating = rating
            print("saved rating: \(self.rating)")
        }
        if let isFavorite = isFavorite {
            self.isFavorite = NSNumber(value: isFavorite) as! Bool
            print("saved isFavorite: \(self.isFavorite)")
        }
        if let isWatched = isWatched {
            self.isWatched = NSNumber(value: isWatched) as! Bool
            print("saved isWatched: \(self.isWatched)")
        }
        if let comment = comment {
            self.comment = comment
            print("saved comment: \(self.comment ?? "is Empty")")
        }
        if let recomendedMovies = recommendedMovies {
            self.recommendedMovies = recomendedMovies
            print("saved recommendedMovies: \(self.recommendedMovies ?? "is Empty")")
        }
        if let voteAverage = voteAverage {
            self.voteAverage = voteAverage
            print("saved voteAverage: \(self.voteAverage)")
        }
        if let watchProviders = watchProviders {
            self.watchProviders = watchProviders
            print("saved watchProviders: \(self.watchProviders ?? "is Empty")")
        }
        
        if self.hasChanges {
            movieStore.saveContext()
        }
    }}
