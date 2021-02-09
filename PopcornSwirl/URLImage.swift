//
//  ImageCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/11/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI


// General Image Card
struct URLImage: View {
    var url: URL?
    var width: CGFloat = 150
    var height: CGFloat = 250
    var alignment: Alignment = .center
    var cornerRadius: CGFloat = 12
    var shadowRadius: CGFloat = 5
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url,
                       placeholder: { Color.purple.opacity(0.8) },
                       image: { Image(uiImage: $0).resizable() })
                .clipShape( RoundedRectangle(cornerRadius: cornerRadius) )
                .frame(width: width, height: height, alignment: alignment)
                .shadow(radius: shadowRadius)
        } else {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: width, height: height)
                .foregroundColor(Color.purple.opacity(0.8) )
                .shadow(radius: shadowRadius)
        }
        
    }
    
}

// Card to hold movie posters
struct ImageCard: View {
    var url: URL?
    var movie: Movie
    @State var isFavorite: Bool = false
    var movieRatings: MovieRatingStore?
    
    var body: some View {
        
        URLImage(url: url)
            .overlay(
                HeartButton(movie: movie)
                    .padding()
                    .shadow(radius: 5.0)
                , alignment: .bottomTrailing)
        

    } // Body
     
}

// Card to hold actor posters
struct LabeledImageCard: View {
    let url: URL?
    var title: String?
    var subtitle: String?
    var movie: Movie?
    var actor: Actor?
    @State var isFavorite: Bool = false
    @State var titlesAreShown: Bool = false // If there are titles ? adjust frame : leave frame constrained
    
    
    var body: some View {
        if let movie = movie {
            VStack(alignment: .leading) {
                // Image
                
                URLImage(url: url)
                    .overlay(
                        HeartButton(movie: movie)
                            .padding()
                            .shadow(radius: 5.0)
                        , alignment: .bottomTrailing )
                
                // Labels
                VStack {
                    if let title = title {
                        Text(title)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .frame(width: 140,
                                   height: 40)
                            .foregroundColor(.pGray3)
                    }
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundColor(.pGray3)
                            .opacity(0.7)
                            .frame(width: 140, height: 20)
                    }
                    
                } // Labels VStack
                .frame(width: titlesAreShown ? 140 : nil, height: titlesAreShown ? 60 : nil , alignment: .center)
                .padding(.vertical, titlesAreShown ? 4 : 0)
                
                .onAppear(perform: {
                    if title != nil || subtitle != nil {
                        self.titlesAreShown = true
                    }
                    
                })
                
            } // VStack(alignment: .leading)
        }
        
        if let actor = actor {
            VStack(alignment: .leading) {
                // Image
                
                URLImage(url: url)
                    .overlay(
                        HeartButton(actor: actor)
                            .padding()
                            .shadow(radius: 5.0)
                        , alignment: .bottomTrailing )
                
                // Labels
                VStack {
                    if let title = title {
                        Text(title)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .frame(width: 140,
                                   height: 40)
                            .foregroundColor(.pGray3)
                    }
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundColor(.pGray3)
                            .opacity(0.7)
                            .frame(width: 140, height: 20)
                    }
                    
                } // Labels VStack
                .frame(width: titlesAreShown ? 140 : nil, height: titlesAreShown ? 60 : nil , alignment: .center)
                .padding(.vertical, titlesAreShown ? 4 : 0)
                
                .onAppear(perform: {
                    if title != nil || subtitle != nil {
                        self.titlesAreShown = true
                    }
                    
                })
                
            } // VStack(alignment: .leading)
        }
        
    } // Body
    
}


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
//        else {
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(.lightBlue)
//                .frame(width: width,
//                       height: height)
//                .overlay(
//                    Text("No Movie Found").foregroundColor(.pGray2)
//                    , alignment: .center)
//        }
        
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

//
//struct ImageCard_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            LabeledMovieCard(url: URL(string: ""), title: "Name", subtitle: "Subtitle")
//            .previewLayout(.sizeThatFits)
//        }
//    }
//}
//
