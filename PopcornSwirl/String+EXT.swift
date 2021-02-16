//
//  String+EXT.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/16/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateformatter.date(from: self ) else { return nil }
        return date
    }
 
}
