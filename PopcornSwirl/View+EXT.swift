//
//  View+EXT.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/25/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import UIKit
import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension View {
    // func to change our view to UIView, then  call another func to convert the new UIVew to a UIImage
    public func convertToUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.frame = CGRect(x: 0,
                                       y: CGFloat(Int.max),
                                       width: 1,
                                       height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        // convert UIView to UIImage
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
    
    
}






#endif



