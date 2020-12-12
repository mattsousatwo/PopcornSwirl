//
//  SavedMovies.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/24/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SavedMovies: View {
    
    
    @Binding var bindingString: String // PLACEHOLDER
    
    var body: some View {
        
        GeometryReader { _ in
        
        
    
         
                SavedRow(search: $bindingString)
      
        
        }
        .background(Color.pGray3)
        .edgesIgnoringSafeArea(.bottom)
        
        .navigationTitle(Text("Saved Movies"))
        
    } // Body
} // SavedMovies()

struct SavedRow: View {
    
    @ObservedObject var movieStore = MovieStore()
    
    var searchResults = [Poster]()
    @Binding var search: String
    
    
    var elements = ["Indiana Jones", "Die Hard", "Double Jeprody", "Tropic Thunder", "Alladin", "The Lion king", "Space Jam", "Avatar", "Casino Royal", "Iorn Man", "Star Trek", "2012", "Ocean Twelve", "Pokemon", "The Karate Kid"]
    
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
            ScrollView {
                VStack {
                
                    ForEach(elementsArray, id: \.self) { array in
                        HStack {
                            ForEach(array, id: \.self) { x in
                                MovieCard(color: .pPurple).overlay(
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
            } // Scroll
        } // Geo
        
        .padding(.bottom)
        
        .onAppear {
            
            movieStore.fetchResultsForMovie(query: search)
        }
   
    }
    
}

struct SavedMovies_Previews: PreviewProvider {
    static var previews: some View {
//        SavedMovies()
        
        SavedRow(search: .constant("String")).previewLayout(.sizeThatFits)
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
