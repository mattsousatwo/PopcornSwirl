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
struct ImageCard: View {
    var url: URL?
    var width: CGFloat = 150
    var height: CGFloat = 250
    var cornerRadius: CGFloat = 12
    var shadowRadius: CGFloat = 5
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url,
                       placeholder: { Color.purple.opacity(0.8) },
                       image: { Image(uiImage: $0).resizable() })
                .clipShape( RoundedRectangle(cornerRadius: cornerRadius) )
                .frame(width: width, height: height)
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
struct MovieCard: View {
    var url: URL?
    var rating: Rating?
    @State var isFavorite: Bool = false
    var movieRatings: MovieRatingStore?
    
    var body: some View {
        if let rating = rating { // Has Rating - update coredata in Button
            ImageCard(url: url)
                .overlay(
                    HeartButton(rating: rating)
                        .frame(width: 25, height: 25)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
            
        } else { // - No Rating - Toggle Button
            ImageCard(url: url)
                .overlay(
                    HeartButton(rating: nil)
                        .frame(width: 25, height: 25)
                        .padding()
                        .shadow(radius: 5.0)
                    ,alignment: .bottomTrailing)
        }
        
//        ImageCard(url: url)
//
//
//                    .overlay(
//
//                        HeartButton(type: rating.isFavorite ?  .fill : .empty )
//                                            Button(action: {
//                                                self.isFavorite.toggle()
//                                                print("HeartButton Pressed")
//
//                                                // Attempting to update MovieRating but button is not being responsive
//                                                guard let rating = rating else { return }
//                                                rating.isFavorite = self.isFavorite
//                                                guard let movieRatings = movieRatings else { return }
//                                                movieRatings.saveContext()
//                                                print("Rating: \(rating.id), isFav: \(rating.isFavorite)")
//
//
//                                            }, label: {
//                                                HeartButton(type: isFavorite ? .fill : .empty)
//                                                    .frame(width: 25, height: 25)
//                                                    .padding()
//                                                    .shadow(radius: 5.0)
//                                            })
//
//                        , alignment: .bottomTrailing)
//
        
    } // Body
    
}

// Card to hold actor posters
struct ActorCard: View {
    let url: URL?
    var name: String
    var subtitle: String
    var rating: Rating?
    @State var isFavorite: Bool = false
    
    var body: some View {
        if let url = url {
            VStack(alignment: .leading) {
                // Image
                AsyncImage(url: url,
                           placeholder: { Color.purple.opacity(0.8) },
                           image: {Image(uiImage: $0).resizable() })
                    .clipShape( RoundedRectangle(cornerRadius: 12) )
                    .frame(width: 150, height: 250)
                    .shadow(radius: 5)
                    .overlay(
                        Button(action: {
                            self.isFavorite.toggle()
                        }, label: {
                            HeartButton(rating: rating)
                                .frame(width: 25, height: 25)
                                .padding()
                                .shadow(radius: 5.0)
                        }) , alignment: .bottomTrailing)
                // Labels
                VStack {
                    Text(name)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .frame(width: 140,
                               height: 40)
                        .foregroundColor(.pGray3)
                    
                    Text(subtitle)
                        .foregroundColor(.pGray3)
                        .opacity(0.7)
                        .frame(width: 140, height: 20)
                    
                    
                } // Labels VStack
                .frame(width: 140, height: 60, alignment: .center)
                .padding(.vertical, 4)
                
            } // VStack(alignment: .leading)
            
        } // If let
    } // Body
    
}


// View to display a Large Card for Actor
struct LargeActorCard: View {
    let url: URL?
    var rating: Rating?
    @State var isFavorite: Bool = false
    
    var body: some View {
        
        if let url = url {
        AsyncImage(url: url,
                   placeholder: { Color.purple },
                   image: { Image(uiImage: $0).resizable() })
            .clipShape( RoundedRectangle(cornerRadius: 12) )
            .frame(width: UIScreen.main.bounds.width / 2,
                   height: 300,
                   alignment: .center)
            .shadow(radius: 5.0)
            .padding()
            .overlay(
                Button(action: {
                    self.isFavorite.toggle()
                },
                label: {
                    HeartButton(rating: rating)
                        .frame(width: 25, height: 25)
                        .padding()
                        
                        .shadow(radius: 5.0)
                })
                , alignment: .bottomTrailing)
            
            
            
            
            
        } // if let
        
    } // body
}


struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActorCard(url: URL(string: ""), name: "Name", subtitle: "Subtitle")
        LargeActorCard(url: URL(string: "") ).previewLayout(.sizeThatFits)
        }
    }
}
 
