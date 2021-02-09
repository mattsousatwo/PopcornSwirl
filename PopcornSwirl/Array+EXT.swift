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
    mutating func limited(append element: Self.Element, _ size: Int = 25) {
        if self.count != size {
            self.append(element)
        }
    }
    
    
    /// Append contents of array into an array if the new arrays size is under a specified count
    mutating func limitedAppend(contents elements: [Self.Element], _ size: Int = 25) {
        for element in elements {
            if self.count != size {
                self.append(element)
            }
        }
    }
    
    
    
    
    
    
}
