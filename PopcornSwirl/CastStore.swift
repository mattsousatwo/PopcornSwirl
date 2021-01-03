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
    
    func createCastMember(actorID: Double, movieID: Double) {
        
        for actor in castMembers {
            if actor.actorID != actorID {
                let newCastMember = Cast(context: context)
                newCastMember.actorID = actorID
                newCastMember.movieID = movieID
                saveContext()
                castMembers.append(newCastMember)
            }
        }
        
        
    }
    
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
    
}



enum CastKeys: String {
    case entity = "Cast"
    case actorID = "actorID"
    case movieID = "movieID"
}
