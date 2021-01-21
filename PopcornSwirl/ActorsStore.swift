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
    
    func createActor(name: String, bio: String?, id: Double, image: UIImage?) {
        let actor = fetchActorWith(id: id)
        
//        let actor = Actor(context: context)
        switch actor.id {
        case id:
            break
        default:
            actor.name = name
            actor.id = id
            if let image = image {
//                let asUIImage: UIImage = image.convertToUIImage()
//                let imageAsData = asUIImage.jpegData(compressionQuality: 1.0)
                
                let imageAsData = image.jpegData(compressionQuality: 1.0)
                actor.image = imageAsData  // Find out how to store Image as Data
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
        
        guard let movie = movie else { return }
        if movie.movieCast.isEmpty == true {
            movie.fetchMovieCreditsForMovie(id: id)
        }
        let actorsForMovie: [MovieCast] = movie.movieCast
        
        var actorsArray: [Actor] = []
        
        for castMember in actorsForMovie {
            let request: NSFetchRequest<Actor> = Actor.fetchRequest()
            request.predicate = NSPredicate(format: "id = %ld", Double(castMember.id))
            do {
                let results = try context.fetch(request)
                actorsArray.append(contentsOf: results)
            } catch {
                print(error)
            }

        }
        self.actorsForMovie = actorsArray
        print("ActorsFetched: \(self.actorsForMovie.count)")
    }
    
    
    func fetchActorWith(id: Double) -> Actor {
        var actorsArray: [Actor] = []
        let request: NSFetchRequest<Actor> = Actor.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", id)
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
