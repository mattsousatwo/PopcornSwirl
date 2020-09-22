//
//  MovieCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MovieCard: View {
    
    var color: Color = .blue
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 100, height: 200)
            .foregroundColor(color)
            .shadow(radius: 5)
            
        
        
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieCard().previewLayout(.sizeThatFits)
    }
}
