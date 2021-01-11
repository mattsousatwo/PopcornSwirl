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
    var url: URL
    @State var isFavorite: Bool = false 
    
    var body: some View {
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
                , alignment: .bottomTrailing
            )
        
    }
    
}

// Card to hold actor posters
struct ActorCard: View {
    var body: some View {
        Text("Hello")
    }
}


struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
 
