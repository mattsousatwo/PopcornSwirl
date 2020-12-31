//
//  MovieCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MoviePoster: View {

    @ObservedObject var urlImageModel: URLImageModel
    
    init(urlString: String?) {
        urlImageModel = URLImageModel(url: urlString)
    }
    
    var body: some View {
        
        switch urlImageModel.image {
        case nil:
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 150, height: 300)
                .foregroundColor(.blue)
                .shadow(radius: 5)
        default:
            Image(uiImage: urlImageModel.image!).resizable().clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .frame(width: 150,
                   height: 300)
            .shadow(radius: 5)
        }
        
    }
}

// Used to display movie poster
struct Poster: View {
    
    @ObservedObject var urlImageModel: URLImageModel
    
    var title = String()
    
    init(urlString: String?, title: String) {
        urlImageModel = URLImageModel(url: urlString)
        self.title = title
    }
    
    var body: some View {
        switch urlImageModel.image {
        case nil:
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 150, height: 300)
                .foregroundColor(Color.coral)
                .shadow(radius: 5)
            
        default:
            VStack(alignment: .leading) {
                Image(uiImage: urlImageModel.image!).resizable().clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                
                .frame(width: 150, height: 250)
                .shadow(radius: 5)
                
                    
                Text(title).foregroundColor(.black).lineLimit(2).fixedSize(horizontal: false, vertical: true )
                        .frame(width: 150, height: 50)
                

            }
            .frame(width: 150, height: 300)
            
        }

    }
    
    
}


struct ActorCard: View {

    @ObservedObject var actorImage: URLImageModel
    var name: String
    var subtitle: String
    @Binding var favorite: Bool
    
    init(imageURL: String?, name: String, subtitle: String, favorite: Binding<Bool>) {
        actorImage = URLImageModel(url: imageURL)
        self.name = name
        self._favorite = favorite
        self.subtitle = subtitle
    }
    
    var body: some View {
        
        switch actorImage.image {
        case nil:
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 100,
                       height: 200)
                .foregroundColor(.darkBlue)
                .shadow(radius: 5)

        default:
            VStack {
                
                Image(uiImage: actorImage.image!).resizable().clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .frame(width: 100,
                       height: 200)
                .shadow(radius: 5)

                .overlay(
                    
                    Button(action: {
                        self.favorite.toggle()
                        print("favorite button tapped")
                    }, label: {
                        Image(systemName: favorite ? "heart.fill": "heart")
                            .frame(width: 30, height: 30)
                            .padding()
                            .foregroundColor(.pGray3)
                    })

                    , alignment: .bottomTrailing)
                Text(name)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 100,
                           height: 30,
                           alignment: .center)
                    .foregroundColor(.black)
                Text(subtitle)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80,
                           height: 30,
                           alignment: .center)
                    .foregroundColor(.gray)
            } // VStack
            
        } // switch
        
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            MoviePoster(urlString: nil)
            
            Poster(urlString: nil, title: "")
            
            ActorCard(imageURL: nil, name: "Actor Name", subtitle: "Subtitle", favorite: .constant(true))
            
            
        }.previewLayout(.sizeThatFits)
    }
}
