//
//  PopularWidgetView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/12/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI
import Combine


struct PopularWidgetView: View, Equatable {
    static func == (lhs: PopularWidgetView, rhs: PopularWidgetView) -> Bool {
        return lhs.reference == rhs.reference
    }
    
    let reference: PopularReference
    
    
    var backgroundColor: some View {
        return Color.purpleBG
    }
    
    var body: some View {
        
        ZStack {
            backgroundColor
            VStack {
//                URLImage(url: URL(string: ("https://image.tmdb.org/t/p/original" + reference.poster)), width: 80, height: 120)
                Image(uiImage: reference.poster)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 120)
                    .clipShape( RoundedRectangle(cornerRadius: 10) )
                Text(reference.title).font(.system(.footnote, design: .rounded)).bold()
                    .foregroundColor(.pGray3)
                    .frame(width: 140, height: 16)
            }
        }
        
    }
}

//struct PopularWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        PopularWidgetView(reference: PopularReference()).previewLayout(.fixed(width: 169, height: 169))
//    }
//}
