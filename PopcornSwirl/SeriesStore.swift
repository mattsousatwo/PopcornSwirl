//
//  SeriesStore.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/24/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SeriesStore: CoreDataCoder, ObservableObject {

    var context: NSManagedObjectContext
    var entity: NSEntityDescription
    
    override init() { 
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: SeriesStoreKeys.entity.rawValue, in: context)!
    }
}

// MARK: Saving
extension SeriesStore {
    
    /// Save Series Context
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}

// MARK: Create
extension SeriesStore {
    
    /// Create Series with seleteded property
    func createSeries(cast: String? = nil,
                imagePath: String? = nil,
                isFavorite: Bool? = nil,
                overview: String? = nil,
                rating: Double? = nil,
                releaseDate: String? = nil,
                title: String? = nil,
                uuid: Double? = nil) -> Series {
        
        let series = Series(context: context)
        
        if let cast = cast {
            series.cast = cast
        }
        if let imagePath = imagePath {
            series.imagePath = imagePath
        }
        if let isFavorite = isFavorite {
            series.isFavorite = NSNumber(value: isFavorite) as! Bool
        }
        if let overview = overview {
            series.overview = overview
        }
        if let rating = rating {
            series.rating = rating
        }
        if let releaseDate = releaseDate {
            series.releaseDate = releaseDate
        }
        if let title = title {
            series.title = title
        }
        if let uuid = uuid {
            series.uuid = uuid
        }
        if series.hasChanges {
            saveContext()
        }
        
        return series
        
    }

    
}

// MARK: Update
extension SeriesStore {
    
    /// Update Series property
    func update(series: Series,
                cast: String? = nil,
                imagePath: String? = nil,
                isFavorite: Bool? = nil,
                overview: String? = nil,
                rating: Double? = nil,
                releaseDate: String? = nil,
                title: String? = nil,
                uuid: Double? = nil) {
        if let cast = cast {
            series.cast = cast
        }
        if let imagePath = imagePath {
            series.imagePath = imagePath
        }
        if let isFavorite = isFavorite {
            series.isFavorite = NSNumber(value: isFavorite) as! Bool
        }
        if let overview = overview {
            series.overview = overview
        }
        if let rating = rating {
            series.rating = rating
        }
        if let releaseDate = releaseDate {
            series.releaseDate = releaseDate
        }
        if let title = title {
            series.title = title
        }
        if let uuid = uuid {
            series.uuid = uuid
        }
        if series.hasChanges {
            saveContext()
        }
    }
    
}

// MARK: Fetching
extension SeriesStore {
    
    /// Fetch specific Series using ID
    func fetchSeries(uuid searchID: Int) -> Series {
        var series = Series(context: context)
        let request: NSFetchRequest<Series> = Series.fetchRequest()
        request.predicate = NSPredicate(format: "uuid == %i", searchID)
        do {
            let result = try context.fetch(request)
            switch result.isEmpty {
            case true:
                series = createSeries(uuid: Double(searchID))
            case false:
                if let foundSeries = result.first {
                    series = foundSeries
                }
            }
        } catch {
            print(error)
        }
        
        return series
    }
    
    /// Fetch an array of Series
    func fetchArrayOfSeries(withIDs searchIDs: [Int]) -> [Series] {
        var seriesArray: [Series] = []
        for id in searchIDs {
            let series = fetchSeries(uuid: id)
            seriesArray.append(series)
        }
        return seriesArray
    }
    
}

// MARK: Deleting
extension SeriesStore {
    
    /// Delete all Series
    func deleteAllSeries() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: SeriesStoreKeys.entity.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        saveContext()
    }
    
}

enum SeriesStoreKeys: String {
    case entity = "Series"
}
