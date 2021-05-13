//
//  PopularWidgetView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/12/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct PopularWidgetView: View {
    
    var backgroundColor: some View {
        return Color.blue
    }
    
    var body: some View {
        
        ZStack {
            backgroundColor
            VStack {
                URLImage(url: URL(string:""), width: 80, height: 120)
                Text("Mortal Kombat").font(.system(.subheadline, design: .rounded)).bold()
                    .foregroundColor(.pGray3)
            }
        }
        
    }
}

struct PopularWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PopularWidgetView().previewLayout(.fixed(width: 169, height: 169))
    }
}
