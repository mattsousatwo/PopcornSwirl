//
//  HeartButton.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/2/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

struct HeartButton: View {
    
    @State var type: HeartType
    
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
    var body: some View {
        
        Button( action: {
            switch type {
            case .empty:
                self.type = .fill
            case .fill:
                self.type = .empty
            }
        }, label: {
            gradient.mask(
                Image(systemName: type.rawValue).resizable() )
                .shadow(radius: 3)
        })
        
        .animation(.default)
    }
    enum HeartType: String {
        case empty = "heart"
        case fill = "heart.fill"
    }
    
}

struct HeartButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {

            HeartButton(type: .fill)
            HeartButton(type: .empty)
            
        }
        .frame(width: 100,
               height: 100)
        
    }
}
