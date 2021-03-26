//
//  ImageCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

// Card to hold movie posters
struct ImageCard: View, Equatable {
    
    var url: URL?
    var movie: Movie? = nil
    var actor: Actor? = nil
    var series: Series? = nil
    
    var body: some View {
        if let movie = movie {
            URLImage(url: url)
                .overlay(
                    HeartButton(movie: movie)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
                .overlay(
                    FilmButton(movie: movie)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomLeading)
                
                
//                .overlay(
//                    Text("\(movie.title ?? "")")
//                    , alignment: .center)
//
        } else if let actor = actor {
            URLImage(url: url)
                .overlay(
                    HeartButton(actor: actor)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
                
        }
        
        
        if let series = series {
            URLImage(url: url)
                .overlay(
                    HeartButton(series: series)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
        }
        
        

    } // Body
    
    // Equatable
    static func == (lhs: ImageCard, rhs: ImageCard) -> Bool {
        return lhs.url == rhs.url &&
            lhs.movie == rhs.movie &&
            lhs.actor == rhs.actor
    }
    
}

struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
        ImageCard(url: nil,
                  movie: nil,
                  actor: nil)
    }
}
