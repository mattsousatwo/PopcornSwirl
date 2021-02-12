//
//  Array+EXT.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/7/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

extension Array  {
    
    /// Append element if array.count is under a specified size
    mutating func limited(append element: Self.Element, limit: Int = 25) {
        if self.count != limit {
            self.append(element)
        }
    }
    
    
    /// Append contents of array into an array if the new arrays size is under a specified count
    mutating func limitedAppend(contents elements: [Self.Element], limit: Int = 25) {
        for element in elements {
            if self.count != limit {
                self.append(element)
            }
        }
    }
    
    /// Will divide array up into an array of arrays of the element 
    func divided(into size: Int) -> [[Element]] {
        return stride(from: 0,
                      to: count,
                      by: size).map {
                        Array(self[$0..<Swift.min($0 + size, count)])
                      }
    }
    
    
    
    
}
