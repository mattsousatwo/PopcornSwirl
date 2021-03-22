//
//  Genre.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 3/22/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

struct Genre {
    
    let id: Int
    let title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
}


struct GenreDict {
    
    /// Array of Genres
    let genres: [Genre] = [Genre(id: 28,    title: "Action"),
                           Genre(id: 12,    title: "Adventure"),
                           Genre(id: 16,    title: "Animation"),
                           Genre(id: 35,    title: "Comedy"),
                           Genre(id: 80,    title: "Crime"),
                           Genre(id: 99,    title: "Documentary"),
                           Genre(id: 18,    title: "Drama"),
                           Genre(id: 10751, title: "Family"),
                           Genre(id: 14,    title: "Fantasy"),
                           Genre(id: 36,    title: "History"),
                           Genre(id: 27,    title: "Horror"),
                           Genre(id: 10402, title: "Music"),
                           Genre(id: 9648,  title: "Mystery"),
                           Genre(id: 10749, title: "Romance"),
                           Genre(id: 878,   title: "Sci-Fi"),
                           Genre(id: 10770, title: "TV Movie"),
                           Genre(id: 53,    title: "Thriller"),
                           Genre(id: 10752, title: "War"),
                           Genre(id: 37,    title: "Western")]
    
    
    /// Will retrieve array of Genre Names that match givien array of Genre IDs
    func convertGenre(IDs: [Int]) -> [String] {
        var extractedGenreNames: [String] = []
        for (id, genre) in zip(IDs, genres) {
            if genre.id == id {
                extractedGenreNames.append(genre.title)
            }
        }
        return extractedGenreNames
    }
    
    
}
