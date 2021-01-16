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
    
    var rating: Rating?
    @State private var type: HeartType = .empty
    private let movieRatingStore = MovieRatingStore()
    
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                          startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        
        
        Button( action: {
            if let rating = rating {
                switch rating.isFavorite {
                case true:
                    type = .fill
                case false:
                    type = .empty
                }
            }
            
            switch type {
            case .empty:
                self.type = .fill
                guard let rating = rating else { return }
                rating.isFavorite = true
                rating.comment = "Heart Button - pressed @ 3:37"
                movieRatingStore.saveContext()
                print("HeartButton - id: \(rating.id), isFavorite: \(rating.isFavorite)")
            case .fill:
                self.type = .empty
                guard let rating = rating else { return }
                rating.isFavorite = false
                movieRatingStore.saveContext()
                print("HeartButton - id: \(rating.id), isFavorite: \(rating.isFavorite)")
            }
        }, label: {
            gradient.mask(
                Image(systemName: type.rawValue).resizable() )
//                .shadow(radius: 3)
                .shadow(color: .gray, radius: 3, x: 1, y: 2)
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

            HeartButton(rating: nil)
            HeartButton(rating: nil)

        }.previewLayout(.sizeThatFits)
        .frame(width: 100,
               height: 100)

    }
}
