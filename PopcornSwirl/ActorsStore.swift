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
    
    var movie : MovieStore?
    
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
    
    
}

// MARK: Create
extension ActorsStore {
    
    func createActor(name: String, bio: String?, id: Double, imagePath: String? = nil) {
        let actor = fetchActorWith(id: Int(id))
        
//        let actor = Actor(context: context)
        switch actor.id {
        case id:
            break
        default:
            actor.name = name
            actor.id = id
            if let imagePath = imagePath {
                actor.imagePath = imagePath
            }
            if let bio = bio {
                actor.biography = bio
            }
            saveContext()
            actors.append(actor)
        }
        
    }
    
    
    
}


// MARK: Fetching
extension ActorsStore {
    
    // Get all actors
    func fetchAllActors() { // not used
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
    
    func fetchActorsForMovie(id: Int) { // Not used
        
        guard let movie = movie else { return }
        if movie.movieCast.isEmpty == true {
            movie.fetchMovieCreditsForMovie(id: id)
        }
        let actorsForMovie: [MovieCast] = movie.movieCast
        
        var actorsArray: [Actor] = []
        
        for castMember in actorsForMovie {
            let request: NSFetchRequest<Actor> = Actor.fetchRequest()
            request.predicate = NSPredicate(format: "id == %i", castMember.id)
            do {
                let results = try context.fetch(request)
                switch results.isEmpty {
                case true:
                    createActor(name: castMember.name, bio: "", id: Double(castMember.id), imagePath: castMember.profile_path)
                    let actor = actors.first(where: { $0.id == Double(castMember.id) })
                    if let actor = actor {
                        actorsArray.append(actor)
                    }
                default:
                    actorsArray.append(contentsOf: results)
                }
            } catch {
                print(error)
            }

        }
        self.actorsForMovie = actorsArray
        print("ActorsFetched: \(self.actorsForMovie.count)")
    }
    
    
    func fetchActorWith(id: Int) -> Actor { // used a lot
        var actorsArray: [Actor] = []
        let request: NSFetchRequest<Actor> = Actor.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %i", id)
        do {
            actorsArray = try context.fetch(request)
        } catch {
            print(error)
        }
        
        var actor =  Actor(context: context)
        if actorsArray.count != 0 && actorsArray.count == 1 {
            if let firstActor = actorsArray.first {
                actor = firstActor
            }
        }
        print("FetchActor - actor: \(actor.name ?? "name is empty")")
        return actor
        
    }
    
    
    // Return an array of actors with search id
    func fetchActorsWith(ids: [Int]) -> [Actor] {
        var actors: [Actor] = []
        for id in ids {
            let fetchedActor = fetchActorWith(id: id)
            actors.append(fetchedActor)
        }
        return actors
    }
    
    
    
}

// MARK: Delete
extension ActorsStore {
    
    // Delete All
    func deleteAllSavedActors() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ActorKeys.entity.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        saveContext()
    }
    
}

enum ActorKeys: String {
    case entity = "Actor"
    case id = "id"
    case name = "name"
    case image = "image"
    case biography = "biography"
}
