//
//  ImageCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

// Card to hold movie posters
struct ImageCard: View {
    var url: URL?
    var movie: Movie? = nil
    var actor: Actor? = nil
    @State var isFavorite: Bool = false
    
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
        } else if let actor = actor {
            URLImage(url: url)
                .overlay(
                    HeartButton(actor: actor)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
        }

    } // Body
     
}

struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
        ImageCard(url: nil,
                  movie: nil,
                  actor: nil)
    }
}
