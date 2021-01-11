//
//  ImageCache.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/8/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

class OldImageCache {
    
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    
}

extension OldImageCache {
    private static var imageCache = OldImageCache()
    static func getImageCache() -> OldImageCache {
        return imageCache
    }
}

// MARK: -  Apply last section -- Using the Cache --
/// https://schwiftyui.com/swiftui/downloading-and-caching-images-in-swiftui/
