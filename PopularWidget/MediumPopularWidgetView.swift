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
                    .frame(width: 120, height: 145)
                    .clipShape( RoundedRectangle(cornerRadius: 12))
                    .padding(.leading, 6)
                    .padding(.vertical, 5)
                
                VStack {
                    Text(reference.title).font(.system(.headline, design: .rounded)).bold()
                        .foregroundColor(.pGray3)
                        
                    Text(reference.description).lineLimit(4)
                        .font(.system(size: 16, weight: .light, design: .rounded))
                        .foregroundColor(.gray)
                       
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
