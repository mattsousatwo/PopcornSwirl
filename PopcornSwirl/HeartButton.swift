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
    var series: Series? = nil
    var width: CGFloat = 25
    var height: CGFloat = 25
    
    @State private var type: HeartType = .empty
    private let movieStore = MoviesStore()
    private let actorsStore = ActorsStore()
    private let seriesStore = SeriesStore()
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                          startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        
        // MARK: Movies
        if let movie = movie {
            Button( action: {
                switch type {
                case .empty:
                    self.type = .fill
                    movieStore.update(movie: movie, isFavorite: true, comment: "true - \(Date())")
                case .fill:
                    self.type = .empty
                    movieStore.update(movie: movie, isFavorite: false, comment: "false - \(Date())")
                }
            }, label: {
                gradient.mask(
                    Image(systemName: type.rawValue).resizable() )
                    .frame(width: width, height: height)
                    .shadow(color: .gray, radius: 3, x: 1, y: 2)
            })
            .animation(.default)
            .onAppear {
                switch movie.isFavorite {
                case true:
                    type = .fill
                case false:
                    type = .empty
                }
            }
        }
        
        
        // MARK: Actor
        if let actor = actor {
            Button( action: {
                
                switch type {
                case .empty:
                    self.type = .fill
                    actor.isFavorite = true
                    actorsStore.saveContext()
                case .fill:
                    self.type = .empty
                    actor.isFavorite = false
                    actorsStore.saveContext()
                }
            }, label: {
                gradient.mask(
                    Image(systemName: type.rawValue).resizable() )
                    .frame(width: width, height: height)
                    //                .shadow(radius: 3)
                    .shadow(color: .gray, radius: 3, x: 1, y: 2)
            })
            .animation(.default)
            .onAppear {
                switch actor.isFavorite {
                case true:
                    type = .fill
                case false:
                    type = .empty
                }
            }
        }
        
        
        
        
        // MARK: Series
        if let series = series {
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
                    .frame(width: width, height: height)
                    .shadow(color: .gray, radius: 3, x: 1, y: 2)
            })
            .animation(.default)
            .onAppear {
                switch series.isFavorite {
                case true:
                    type = .fill
                case false:
                    type = .empty
                }
            }
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
