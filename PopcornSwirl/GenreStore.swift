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
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func fetchAllGenres() {
        let request: NSFetchRequest<Genres> = Genres.fetchRequest()
        do {
            let requestResults = try context.fetch(request)
            genres = requestResults
        } catch {
            print(error)
        }
    }
    
    
    // Extract genres from id tags
    func extractGenreFrom(ids: [Int]) -> [String] {
        var extractedArray: [String] = []
        if genres.isEmpty {
            fetchAllGenres()
        }
        if genres.count != 0 {
            for genre in genres {
                for id in ids {
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
            }
        }
        
        return extractedArray
    }
    
}

enum GenreKeys: String {
    case entity = "Genres"
    case id = "id"
    case name = "name"
}
