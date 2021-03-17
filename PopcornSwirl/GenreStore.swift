//
//  GenreStore.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/29/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftUI
import Combine

class GenreStore: ObservableObject {
    
    @ObservedObject private var movie = MovieStore()
    
    var context: NSManagedObjectContext
    var entity: NSEntityDescription?
    
    @Published var genres = [Genres]()
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: GenreKeys.entity.rawValue, in: context)!
    }
    
    
    
    /// save all genres
    func setGenreDictionary() {
        fetchAllGenres()

        
        
        
    }
    
    
    
    /// Save genres to device if not already saved
    func initalizeGenres() {
        movie.getGenres()
        print("InitalizeGenres")
        fetchAllGenres()
        
        
        
        if genres.count == 0 {
            if movie.genreDictionary.count != 0 {
                for (id, name) in movie.genreDictionary {
                    createGenre(id: id, name: name)
                    print("InitalizeGenres - NewGenre: \(name), \(id)")
                }
            }
            
        }
    }
    
    /// Create a new Genre Entity
    func createGenre(id: Int, name: String) {
        let genre = Genres(context: context)
        genre.id = Int16(id)
        genre.name = name
        saveContext()
    }
    
    /// Save Genre context
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    /// Fetch all Genre entities
    func fetchAllGenres() {
        let request: NSFetchRequest<Genres> = Genres.fetchRequest()
        do {
            let requestResults = try context.fetch(request)
            genres = requestResults
        } catch {
            print(error)
        }
    }
    
    /// Check if genres are loaded before fetching, & return an array of Genres
    func loadAllGenres() -> [Genres] {
        if genres.isEmpty == true {
            fetchAllGenres()
        }
        return genres
    }
    
    
    /// Extract genres from id tags
    func extractGenreFrom(ids: [Int]) -> [String] {
        var extractedArray: [String] = []
        for (genre, id) in zip(genres, ids) {
            if genre.id == Int16(id) {
                if var name = genre.name {
                    // Configure Names
                    if name == "Science Fiction" {
                        name = "Sci-Fi"
                    }
                    extractedArray.append(name)
                }
            }
        }
        
        for genre in extractedArray {
            print("Extracted Array: \(genre)")
        }
            
            if extractedArray.count == 0 {
                print("Extracted Array: == NIL")
            }
        
        
//
//        if genres.count != 0 {
//            for genre in genres {
//                for id in ids {
//                    if genre.id == Int16(id) {
//
//                        if var name = genre.name {
//                            // Configure Names
//                            if name == "Science Fiction" {
//                                name = "Sci-Fi"
//                            }
//
//                            extractedArray.append(name)
//                        }
//
//                    }
//                }
//            }
//        }
       
        
        
        return extractedArray
    }
    
}

enum GenreKeys: String {
    case entity = "Genres"
    case id = "id"
    case name = "name"
}
