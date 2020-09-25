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
        ScrollView {

            SavedRow()
            
        }// Main Scroll
        .background(Color.pGray)
        .edgesIgnoringSafeArea(.bottom)
        
        .navigationTitle(Text("Saved Movies"))
        
    } // Body
} // SavedMovies()

struct SavedRow: View {
    
    var elements = ["Indiana Jones", "Die Hard", "Double Jeprody", "Tropic Thunder", "Alladin", "The Lion king", "Space Jam", "Avatar"]
    
    private var elementsArray: [[String]] {
        
        var newArray: [[String]] = []

        let dividedCount = elements.count / 3
        
        if dividedCount >= 1 {
            newArray = elements.divided(into: 3)
        } else {
            newArray = [elements]
        }
        
        return newArray
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                ForEach(elementsArray, id: \.self) { array in
                    HStack {
                        ForEach(array, id: \.self) { x in
                            MovieCard().overlay(
                                Text(x).foregroundColor(.white)
                            )
                        } // ForEach(array)
                        .padding(.horizontal, 15)
                        Spacer()
                    } // HStack
                    .frame(width: geometry.size.width,
                           height: 200)
                    
                } // ForEach(elementsArray)
                
            } // VStack

        } // Geo
        .padding(.vertical)
   
    }
}

struct SavedMovies_Previews: PreviewProvider {
    static var previews: some View {
        SavedMovies()
        
        SavedRow().previewLayout(.sizeThatFits)
    }
}


extension Array {
    
    func divided(into size: Int) -> [[Element]] {
        return stride(from: 0,
                      to: count,
                      by: size).map {
                        Array(self[$0..<Swift.min($0 + size, count)])
                      }
    }
}
