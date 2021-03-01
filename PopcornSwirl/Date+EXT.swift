//
//  Date+EXT.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/16/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

extension Date {
    
    var formater: DateFormatter {
        get {
            return DateFormatter()
        }
    }
    
    // return formated time
    func time() -> String {
        formater.dateFormat = "h:mm a"
        
        return formater.string(from: Date() )
    }
    
    // Date for movie release date
    func movieDate() -> String { // not sure if working
        formater.dateFormat = "MMM d, yyyy"
        return formater.string(from: self )
    }
    
    func calculateTime(to rhs: Date) -> Int {
        var age: Int = 0
        let difference = Calendar.current.dateComponents([.year], from: self, to: rhs)
        if let s = difference.year {
            age = s
        }
        return age
    }
    
    
}
