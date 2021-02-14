//
//  LargeImageCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

// View to display a Large Card for Actor
struct LargeImageCard: View {
    var url: URL?
    var movie: Movie?
    var actor: Actor?
    @State var isFavorite: Bool = false
    
    private var width: CGFloat = UIScreen.main.bounds.width / 2
    private var height: CGFloat = 300
    init(url: URL?, movie: Movie? = nil, actor: Actor? = nil) {
        self.url = url
//        self.movie = movie
        self.movie = movie
        self.actor = actor
    }
    
    var body: some View {
        if let movie = movie {
            URLImage(url: url,
                     width: width,
                     height: height,
                     alignment: .center)
                .overlay(
                    HeartButton(movie: movie)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
        }

        // -------------------

        if let actor = actor {
            URLImage(url: url,
                     width: width,
                     height: height,
                     alignment: .center)
                .overlay(
                    HeartButton(actor: actor)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
        } else {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.lightBlue)
                .frame(width: width,
                       height: height)
                .overlay(
                    Text("No Actor Found").foregroundColor(.pGray2)
                    , alignment: .center)
        }
    } // body
}

struct LargeImageCard_Previews: PreviewProvider {
    static var previews: some View {
        LargeImageCard(url: nil)
    }
}
