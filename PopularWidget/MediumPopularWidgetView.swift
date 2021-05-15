//
//  MediumPopularWidgetView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

struct MediumPopularWidgetView: View, Equatable {
    
    let reference: PopularReference
    
    var backgroundColor: some View {
        return Color.purpleBG
    }
    
    var body: some View {
        ZStack {
            backgroundColor
            HStack {
                
                Image(uiImage: reference.poster)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape( RoundedRectangle(cornerRadius: 20))
                    .padding(.leading, 6)
                    .padding(.vertical, 5)
                
                VStack {
                    if reference.title != "" {
                        Text(reference.title).font(.system(.headline, design: .rounded)).bold()
                            .lineLimit(2)
                            .foregroundColor(.pGray3)
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                            .opacity(0.4)
                            .frame(width: 175, height: 20)
                    }
                    
                    if reference.description != "" {
                        Text(reference.description).lineLimit(4)
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .foregroundColor(.gray)
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.white)
                            .opacity(0.4)
                            .frame(width: 175, height: 80)
                    }
                    

                       
                }
                .frame(width: 175, height: 190, alignment: .leading)
                .padding(.horizontal, 6)
            }
            
        }
        
        
    }
    
}

struct MediumPopularWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        MediumPopularWidgetView(reference: PopularReference(title: "Mortal Kombat", description: "Earths greatest fighters ban toghther to fight in a tournament to save the world from being destroyed from the underworld")).previewLayout(.fixed(width: 169, height: 169))
    }
}
