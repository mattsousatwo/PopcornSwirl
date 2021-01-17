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
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
            
        } else { // - No Rating - Toggle Button
            ImageCard(url: url)
                .overlay(
                    HeartButton(rating: nil)
                        .padding()
                        .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
        }

    } // Body
     
}

// Card to hold actor posters
struct LabeledMovieCard: View {
    let url: URL?
    var title: String?
    var subtitle: String?
    var rating: Rating?
    @State var isFavorite: Bool = false
    @State var titlesAreShown: Bool = false
    
    
    var body: some View {
        
            VStack(alignment: .leading) {
                // Image
                if let rating = rating {
                    ImageCard(url: url)
                        .overlay(
                            HeartButton(rating: rating)
                                .padding()
                                .shadow(radius: 5.0)
                            , alignment: .bottomTrailing )
                } else {
                    ImageCard(url: url)
                        .overlay(
                            HeartButton(rating: rating)
                                .padding()
                                .shadow(radius: 5.0)
                            ,alignment: .bottomTrailing)
                }
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
            
        
    } // Body
    
}


// View to display a Large Card for Actor
struct LargeActorCard: View {
    var url: URL?
    var rating: Rating?
    @State var isFavorite: Bool = false
    
    private var width: CGFloat = UIScreen.main.bounds.width / 2
    private var height: CGFloat = 300
    init(url: URL?, rating: Rating?) {
        self.url = url
        self.rating = rating 
    }
    
    var body: some View {
        if let rating = rating {
            ImageCard(url: url,
                      width: width,
                      height: height,
                      alignment: .center)
                .overlay(
                        HeartButton(rating: rating)
                            .padding()
                            .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
        } else {
            ImageCard(url: url,
                      width: width,
                      height: height,
                      alignment: .center)
                .overlay(
                        HeartButton(rating: nil)
                            .padding()
                            .shadow(radius: 5.0)
                    , alignment: .bottomTrailing)
        }
        
    } // body
}


struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LabeledMovieCard(url: URL(string: ""), title: "Name", subtitle: "Subtitle")
            .previewLayout(.sizeThatFits)
        }
    }
}
 
