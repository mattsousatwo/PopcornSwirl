//
//  ImageCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/11/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

// Card to hold movie posters
struct MovieCard: View {
    var url: URL?
    @State var isFavorite: Bool = false 
    
    var body: some View {
        if let url = url {
        AsyncImage(url: url,
                   placeholder: { Color.purple.opacity(0.8) },
                   image: { Image(uiImage: $0).resizable() })
            .clipShape( RoundedRectangle(cornerRadius: 12) )
            .frame(width: 150, height: 250)
            .shadow(radius: 5)
            .overlay(
                Button(action: {
                    self.isFavorite.toggle() // HeartButton is inside a Button to access CoreData.isFavorite
                }, label: {
                    HeartButton(type: isFavorite ? .fill : .empty)
                        .frame(width: 25, height: 25)
                        .padding()
                        .shadow(radius: 5.0)
                })
                , alignment: .bottomTrailing)
        }
    } // Body
    
}

// Card to hold actor posters
struct ActorCard: View {
    let url: URL?
    var name: String
    var subtitle: String
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
                            HeartButton(type: isFavorite ? .fill : .empty)
                                .frame(width: 25, height: 25)
                                .padding()
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


struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
 
