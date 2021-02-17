//
//  FilmButton.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct FilmButton: View {
    
    var movie: Movie?
    var width: CGFloat = 25
    var height: CGFloat = 25
        
    @State private var type: FilmType = .unWatched
    private let movieStore = MoviesStore()
    private let gradient = LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                          startPoint: .top, endPoint: .bottom)

    var body: some View {
        
        if let movie = movie {
            Button( action: {
                switch type {
                case .unWatched:
                    self.type = .watched
                    movieStore.update(movie: movie, isWatched: true)
                    print("movie: \(movie.title ?? "NO TITLE"), isWatched: \(movie.isWatched)")
                case .watched:
                    self.type = .unWatched
                    movieStore.update(movie: movie, isWatched: false)
                    print("movie: \(movie.title ?? "NO TITLE"), isWatched: \(movie.isWatched)")
                }

            }, label: {
                gradient.mask(
                    Image(systemName: type.rawValue).resizable() )
                    .frame(width: width, height: height)
                    .shadow(color: .gray, radius: 3, x: 1, y: 2)
            })
            .animation(.default)
            .onAppear(perform: {
                switch movie.isWatched {
                case true:
                    type = .watched
                case false:
                    type = .unWatched
                }
                print("movie: \(movie.title ?? "NO TITLE"), isWatched: \(movie.isWatched)")
            })


        }
        
    }
    
}

struct FilmButton_Previews: PreviewProvider {
    static var previews: some View {
        FilmButton()
    }
}

enum FilmType: String {
    case unWatched = "film"
    case watched = "film.fill"
}
