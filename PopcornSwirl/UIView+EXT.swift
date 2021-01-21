//
//  UIView+EXT.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/18/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // Will Convert a UIView to UIImage 
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    
}
