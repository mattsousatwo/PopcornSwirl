//
//  CastStore.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/31/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import Combine
import UIKit

class CastStore: ObservableObject {
    
    var context: NSManagedObjectContext
    var entity: NSEntityDescription
    
    @ObservedObject var actorsStore = ActorsStore()
    @Published var actorsForMovie = [Actor]()
    @Published var castMembers = [Cast]()
    
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: CastKeys.entity.rawValue, in: context)!
        
    }
    
   
}

// MARK: - Fetch
extension CastStore {
    
    // Use Movie ID to fetch Actors of movie
    func fetchActorsInMovieCastWith(id: Double) {
        actorsForMovie.removeAll()
        if castMembers.contains(where: { $0.movieID == id }) == false {
            fetchCastForMovie(id: id)
            for actor in castMembers {
                if actor.movieID == id {
                    let newActor = actorsStore.fetchActorWith(id:  actor.actorID)
                    actorsForMovie.append(newActor)
                }
            }

        } else {
            for actor in castMembers {
                if actor.movieID == id {
                    let newActor = actorsStore.fetchActorWith(id:  actor.actorID)
                    actorsForMovie.append(newActor)
                }
            }
        }
        
    }
    
    func fetchAllCastEntities() {
        let request: NSFetchRequest<Cast> = Cast.fetchRequest()
        do {
            let requestResults = try context.fetch(request)
            castMembers = requestResults
        } catch {
            print(error)
        }
    }
    
    // Get cast for a specific movie and add to castMembers
    func fetchCastForMovie(id: Double) {
        let request : NSFetchRequest<Cast> = Cast.fetchRequest()
        let moviePredicate = NSPredicate(format: "movieID = %ld", id)
        request.predicate = moviePredicate
        do {
            let results = try context.fetch(request)
            
            castMembers.append(contentsOf: results)
        } catch {
            print(error)
        }

    }
    
}


// MARK: - Create
extension CastStore {
    // MARK: - Creates doubles
    func createCastMember(actorID: Double, movieID: Double) {  
        
        let actorsInMovie = castMembers.filter { $0.movieID == movieID }
        
        if actorsInMovie.count <= 24 {  // If actors count == full
            
            // fetchEntries if castmembers is empty
            if castMembers.isEmpty == true {
                print("castMembers.isEmpty == true")
                fetchAllCastEntities()   // MARK: Can change this to fetchCastFrom(movieID: )
            }
                    
            if castMembers.isEmpty == true { // if there are no entries create inital entry
                let firstActor = Cast(context: context)
                firstActor.actorID = actorID
                firstActor.movieID = movieID
                saveContext()
                castMembers.append(firstActor)
                print("CreateCastMember(id: \(actorID), movie: \(movieID) -- FIRST MEMBER SAVED)")
            }

            // Check if actorID is already in castMembers
            var memberID: Double = 0
            for member in castMembers {
                if member.movieID == movieID && member.actorID == actorID {
                    memberID = actorID
                    print("MATCH - inCast: \(member.actorID)\n         newID: \(actorID)")
                }
            }
            // add new cast member if not double
            switch memberID {
            case actorID: // double
                break
            default: // not double
                let actor = Cast(context: context)
                actor.actorID = actorID
                actor.movieID = movieID
                saveContext()
                castMembers.append(actor)
                print("New Cast Member - ID: \(actorID), movie: \(movieID)")
            }
            print("CastMemberCount: \(castMembers.count)")
        }
        
        print("Movie already saved: \(movieID)")
    } // func
    
    
}



// MARK: - Save
extension CastStore {
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }

    }
    
}

// MARK: - Delete
extension CastStore {
    
    func deleteAll() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CastKeys.entity.rawValue)
//        request.predicate = NSPredicate(format: "goal_UID = %@", tag)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        saveContext()
        
    }

    
    
}



enum CastKeys: String {
    case entity = "Cast"
    case actorID = "actorID"
    case movieID = "movieID"
}
