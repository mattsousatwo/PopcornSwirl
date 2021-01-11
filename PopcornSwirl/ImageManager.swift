//
//  ImageManager.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/8/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

class ImageManager {
    
}

class URLImageModel: ObservableObject {
    
    @Published var image: UIImage?
    
    var imageCache = OldImageCache.getImageCache()
    
    var urlString: String?
    
    init(url: String?) {
        self.urlString = url
        loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        loadImageFromURL()
    }
    
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        
        return true
    }
    
    func loadImageFromURL() {
        guard let urlString = urlString else { return }
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        guard error == nil else {
            print("Error: \(error!)")
            return }
        
        guard let data = data else {
            print("no data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.imageCache.set(forKey: self.urlString!, image: loadedImage)
            self.image = loadedImage
        }
        
        
    }
    
}
