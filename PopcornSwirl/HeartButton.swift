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
    
    var actor: Actor?
    var movie: Movie?
    var width: CGFloat = 25
    var height: CGFloat = 25
    
    @State private var type: HeartType = .empty
    private let movieStore = MoviesStore()
    private let actorsStore = ActorsStore()
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                          startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        
        
        if let movie = movie {
            Button( action: {
                switch movie.isFavorite {
                case true:
                    type = .fill
                case false:
                    type = .empty
                }
                
                
                switch type {
                case .empty:
                    self.type = .fill
                    print("Like Button Pressed")
                    movie.isFavorite = true
                    movie.comment = "Heart Button - pressed @ 3:37"
                    movieStore.saveContext()
                    print("HeartButton - id: \(movie.uuid), isFavorite: \(movie.isFavorite)")
                case .fill:
                    self.type = .empty
                    print("Unlike Button Pressed")
                    movie.isFavorite = false
                    movieStore.saveContext()
                    print("HeartButton - id: \(movie.uuid), isFavorite: \(movie.isFavorite)")
                }
            }, label: {
                gradient.mask(
                    Image(systemName: type.rawValue).resizable() )
                    .frame(width: width, height: height)
                    //                .shadow(radius: 3)
                    .shadow(color: .gray, radius: 3, x: 1, y: 2)
            })
            .animation(.default)
        } else {
            if let actor = actor {
                Button( action: {
                    switch actor.isFavorite {
                    case true:
                        type = .fill
                    case false:
                        type = .empty
                    }
                    switch type {
                    case .empty:
                        self.type = .fill
                        print("Like Button Pressed")
                        actor.isFavorite = true
                        actorsStore.saveContext()
                        print("HeartButton - actorID: \(actor.id), isFavorite: \(actor.isFavorite)")
                    case .fill:
                        self.type = .empty
                        print("Unlike Button Pressed")
                        actor.isFavorite = false
                        actorsStore.saveContext()
                        print("HeartButton - actorID: \(actor.id), isFavorite: \(actor.isFavorite)")
                    }
                }, label: {
                    gradient.mask(
                        Image(systemName: type.rawValue).resizable() )
                        .frame(width: width, height: height)
                        //                .shadow(radius: 3)
                        .shadow(color: .gray, radius: 3, x: 1, y: 2)
                })
                .animation(.default)
            }

            
//
//            if let actor = actor {
//                switch actor.isFavorite {
//                case true:
//                    type = .fill
//                default:
//                    type = .empty
//                }
//
//
//            }
            
        }
        
        

        
        
        
        
    }
    enum HeartType: String {
        case empty = "heart"
        case fill = "heart.fill"
    }
    
}

//struct HeartButton_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//
//            HeartButton(movie: nil)
//            HeartButton(movie: nil)
//
//        }.previewLayout(.sizeThatFits)
//        .frame(width: 100,
//               height: 100)
//
//    }
//}
