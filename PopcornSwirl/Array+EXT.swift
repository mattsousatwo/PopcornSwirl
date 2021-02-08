//
//  Array+EXT.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/7/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

extension Array  {
    
    mutating func limited(append element: Self.Element, _ size: Int = 25) {
        if self.count != size {
            self.append(element)
        }

    }
    
}
