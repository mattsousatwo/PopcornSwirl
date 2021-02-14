//
//  LabeledImageCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

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
        
        VStack(alignment: .leading) {
            // Image
            ImageCard(url: url,
                      movie: movie,
                      actor: actor)
            
            
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


struct LabeledImageCard_Previews: PreviewProvider {
    static var previews: some View {
        LabeledImageCard(url: nil)
    }
}
