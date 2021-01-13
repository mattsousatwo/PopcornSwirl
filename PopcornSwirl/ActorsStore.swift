//
//  ActorsStore.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/30/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData
import Combine
import SwiftUI

class ActorsStore: ObservableObject {
    
//    @ObservedObject var movie = MovieStore()
    
    var context: NSManagedObjectContext
    var entity: NSEntityDescription
    
    @Published var actors = [Actor]()
    @Published var actorsForMovie = [Actor]()
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: ActorKeys.entity.rawValue, in: context)!
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    // Get all actors
    func fetchAllActors() {
        let request: NSFetchRequest<Actor> = Actor.fetchRequest()
        do {
            actors = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    // MARK: HOW TO GET ACTORS WITH MOVIEID
    //// use MovieStore.fetchMovieCreditsFroMovie(id: Int) to get MovieCast
    //// MovieStore.movieCast holds All actors
    
    func fetchActorsForMovie(id: Int) {
        
//        if actors.isEmpty {
//
//        }
//
//        movie.fetchMovieCreditsForMovie(id: id)
//
//        let actorsForMovie: [MovieCast] = movie.movieCast
//
//
        
    }
    
    
    func fetchActorWith(id: Double) -> Actor {
        var actorsArray: [Actor] = []
        let request: NSFetchRequest<Actor> = Actor.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        do {
            actorsArray = try context.fetch(request)
        } catch {
            print(error)
        }
        
        var actor = Actor(context: context)
        if actorsArray.count != 0 && actorsArray.count == 1 {
            actor = actorsArray.first!
        }
        
        return actor
        
    }
    
}


enum ActorKeys: String {
    case entity = "Actor"
    case id = "id"
    case name = "name"
    case image = "image"
    case biography = "biography"
}
