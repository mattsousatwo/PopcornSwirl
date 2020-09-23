//
//  Star.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct Star: View {
    
    
    //                      (X: Left, Right, Y: Up, Down)
    
    var rect: CGSize
  
    var body: some View {
        
        
        
        // Center
        let centerX = rect.width / 2
        let centerY = rect.height / 2
        // Furthest points
        let top = centerY - 75
        let bottom = centerY + 100
        let leading = centerX - 100
        let trailing = centerX + 100

        // Outer Points
        let outsideTop = CGPoint(x: centerX, y: top)
        let outsideRightTop = CGPoint(x: trailing, y: centerY)
        let outsideRightBottom = CGPoint(x: trailing - 30, y: bottom)
        let outsideLeftTop = CGPoint(x: leading, y: centerY )
        let outsideLeftBottom = CGPoint(x: leading + 30, y: bottom)
        
        // Inner Points
        let rightInnerTop = CGPoint(x:  centerX + 30, y: centerY - 5)
        let rightInnerBottom = CGPoint(x: centerX + 50, y: centerY + 40)
        let innerCenter = CGPoint(x: centerX , y: centerY + 60)
        let leftInnerTop = CGPoint(x: centerX - 30, y: centerY - 5)
        let leftInnerBottom = CGPoint(x: centerX - 50, y: centerY + 40)
        
        Path { path in
        path.move(to: outsideTop) // (CENTER,UP) - TOP RIGHT
        
        
            path.addLine(to: rightInnerTop) // (RIGHT, DOWN)
        
        path.addLine(to: outsideRightTop) // (RIGHT, CENTER) - RIGHT TOP
        
            path.addLine(to: rightInnerBottom) // (LEFT, DOWN)
        
        path.addLine(to: outsideRightBottom) // (RIGHT, DOWN) - RIGHT BOTTOM
        
            path.addLine(to: innerCenter) // (LEFT, UP )
        
        path.addLine(to: outsideLeftBottom) // (LEFT, DOWN) - LEFT BOTTOM
        
            path.addLine(to: leftInnerBottom) // (RIGHT, UP)
        
        path.addLine(to: outsideLeftTop) // (LEFT, UP) - LEFT TOP
        
            path.addLine(to: leftInnerTop) // (RIGHT, center)
        
        path.addLine(to: outsideTop) // (RIGHT, UP) - TOP LEFT
        
        
        
        path.closeSubpath()
        
        
            
        }
        .fill(Color.green)

        
    }
    
}



struct Star_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Star(rect: CGSize(width: 200, height: 200))
                .previewLayout(.sizeThatFits)
                .foregroundColor(.yellow)
            Star(rect: CGSize(width: 200, height: 200))

                .foregroundColor(.lightYellow)
                
            
            
        }
    }
}
