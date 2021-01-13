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
    
    // Use Movie ID to fetch cast of movie
    func fetchMovieCastWith(id: Double) {
        actorsForMovie.removeAll()
        for actor in castMembers {
            if actor.movieID == id {
                
                let newActor = actorsStore.fetchActorWith(id:  actor.actorID)
                actorsForMovie.append(newActor)
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
    
    
}


// MARK: - Create
extension CastStore {
    // MARK: - Creates doubles
    func createCastMember(actorID: Double, movieID: Double) {  // Currently Creates 4 duplicates
        
        let actorsInMovie = castMembers.filter { $0.movieID == movieID }
        
        if actorsInMovie.count <= 24 {
            
            // fetchEntries if castmembers is empty
            if castMembers.isEmpty == true {
                print("castMembers.isEmpty == true")
                fetchAllCastEntities()
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
