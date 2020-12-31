//
//  MoviesStore.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/30/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

class MoviesStore: ObservableObject {
    
    var context: NSManagedObjectContext
    var entity: NSEntityDescription
    
    @ObservedObject private var movieStore = MovieStore()
    
    @Published var popularMovies = [PopMovie]()
    @Published var upcommingMovies = [UpcomingMovie]()
    
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: MovieKeys.entity.rawValue, in: context)!
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    
    func loadUpcommingAndPopularMovies() {
        
    }
    
    func fetchPopularMovies() {
        movieStore.fetchPopularMovies()
        
//        if movieStore.popularMovies
        
        
    }
    
    
}


enum MovieKeys: String {
    case entity = "Movies"
    
}
