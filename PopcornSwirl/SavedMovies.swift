//
//  SavedMovies.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/24/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SavedMovies: View {
    
    var body: some View {
        
        GeometryReader { geometry in
//                SavedRow(search: $bindingString)
            Text("SavedMovies")
      
        
        }
        .background(Color.pGray3)
        .edgesIgnoringSafeArea(.bottom)
        
        .navigationTitle(Text("Saved Movies"))
        
    } // Body
    
} // SavedMovies()

struct SavedMovies_Previews: PreviewProvider {
    static var previews: some View {
        SavedMovies()
        
       
    }
}

