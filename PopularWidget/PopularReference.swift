//
//  PopularWidgetManager.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftUI

class PopularReference: Equatable {
    static func == (lhs: PopularReference, rhs: PopularReference) -> Bool {
        return lhs.poster == rhs.poster &&
            lhs.description == rhs.description &&
            lhs.title == rhs.title
        
    }
    
    var poster: UIImage
    var title: String
    var description: String
    
    init(poster: UIImage = UIImage(named: "placeholder")!, title: String = "", description: String = "") {
        self.poster = poster
        self.title = title
        self.description = description
    }

}

