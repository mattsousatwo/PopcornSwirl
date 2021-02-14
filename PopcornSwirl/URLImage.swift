//
//  ImageCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/11/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI


// Image that can load from downloaded object 
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
