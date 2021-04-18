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

class ActorsStore: CoreDataCoder, ObservableObject {
    
    var movie : MovieStore?
    
    var context: NSManagedObjectContext
    var entity: NSEntityDescription
    
    @Published var actors = [Actor]()
    @Published var actorsForMovie = [Actor]()
    
    override init() {
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
        let actor = Actor(context: context)
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

extension ActorsStore {
    
    // Update actor properties
    func update(actor: Actor,
                id: Double? = nil,
                imagePath: String? = nil,
                name: String? = nil,
                isFavorite: Bool? = nil,
                credits: String? = nil,
                deathDate: String? = nil,
                birthDate: String? = nil,
                birthPlace: String? = nil,
                bio: String? = nil) {
        
        if let id = id {
            if actor.id != id {
                actor.id = id
            }
        }
        if let imagePath = imagePath {
            if actor.imagePath != imagePath {
                actor.imagePath = imagePath
            }
        }
        if let name = name {
            if actor.name != name {
                actor.name = name
            }
        }
        if let isFavorite = isFavorite {
            if actor.isFavorite != isFavorite {
                actor.isFavorite = NSNumber(value: isFavorite) as! Bool 
            }
        }
        if let credits = credits {
            if actor.credits != credits {
                actor.credits = credits
            }
        }
        if let deathDate = deathDate {
            if actor.deathDate != deathDate {
                actor.deathDate = deathDate
            }
        }
        if let birthDate = birthDate {
            if actor.birthDate != birthDate {
                actor.birthDate = birthDate
            }
        }
        if let birthPlace = birthPlace {
            if actor.birthPlace != birthPlace {
                actor.birthPlace = birthPlace
            }
        }
        if let bio = bio {
            if actor.biography != bio {
                actor.biography = bio
            }
        }
        if actor.hasChanges {
            saveContext()
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
        return actor
        
    }
    
    func fetchAllActorsWith(ids: [Int]) -> [Actor] {
        var actorsArray: [Actor] = []
        let request: NSFetchRequest<Actor> = Actor.fetchRequest()
        for id in ids {
            request.predicate = NSPredicate(format: "id == %i", Int(id))
            do {
                let result = try context.fetch(request)
                switch result.isEmpty {
                case true:
                    let actor = Actor(context: context)
                    actor.id = Double(id)
                    saveContext()
                    actorsArray.append(actor)
                case false:
                    actorsArray.append(contentsOf: result)
                }
            } catch {
                print(error)
            }
        }
        return actorsArray
    }
    
    
    
    
    /// Get all favorited Actors
    func fetchFavoritedActors() -> [[Actor]]? {
        var actorsArray: [Actor] = []
        let request: NSFetchRequest<Actor> = Actor.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        do {
            actorsArray = try context.fetch(request)
        } catch {
            print(error)
        }
        var arrayOfActorArrays: [[Actor]] = []
        if actorsArray.count != 0 {
            let dividedCount = actorsArray.count / 2
            if dividedCount >= 1 {
                arrayOfActorArrays = actorsArray.divided(into: 2)
            } else {
                arrayOfActorArrays = [actorsArray]
            }
        } else {
            return nil
        }
        return arrayOfActorArrays
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
