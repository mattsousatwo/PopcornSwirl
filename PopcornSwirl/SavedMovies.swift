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
        
        GeometryReader { _ in
        
         
//                SavedRow(search: $bindingString)
            Text("SavedMovies")
      
        
        }
        .background(Color.pGray3)
        .edgesIgnoringSafeArea(.bottom)
        
        .navigationTitle(Text("Saved Movies"))
        
    } // Body
} // SavedMovies()

struct SavedRow: View {
    
    @ObservedObject var movieStore = MovieStore()
    
    @Binding var search: String
    
    private var elementsArray: [[MovieSearchResults]] {
        
        movieStore.fetchResultsForMovie(query: search)
        
        var newArray: [[MovieSearchResults]] = []

        let dividedCount = movieStore.movieSearchResults.count / 2
        
        if dividedCount >= 1 {
            newArray = movieStore.movieSearchResults.divided(into: 2)
        }
        print("ElementsArray: \(newArray.count)")
        return newArray
    }
    
    private var showResults: Bool {
        
        switch elementsArray.count {
        case 0:
            return false
        default:
            return true
        }
    }
    
    var body: some View {
        
        
        
        GeometryReader { geometry in
            if showResults == true {
                
                
            ScrollView {
                VStack {
                
                    ForEach(elementsArray, id: \.self) { array in
                        HStack {
                            Spacer()
                            ForEach(array, id: \.self) { movie in
                                
                                Poster(urlString: self.movieStore.imageURL + (movie.poster_path ?? "" ),
                                       title: movie.title)
                            } // ForEach(array)
                            .padding(.horizontal, 15)
                            Spacer()
                        } // HStack
                        .frame(width: geometry.size.width,
                               height: 300,
                               alignment: .center)
                        .padding()
                    } // ForEach(elementsArray)
                    
                } // VStack
            } // Scroll
                
            .animation(.default)
            } else { // show results
                
                Text("No Results Found").padding()
            }
            
            
        } // Geo
        
            .padding(.bottom)
        
        

        
    }
    
    
}

struct SavedMovies_Previews: PreviewProvider {
    static var previews: some View {
        SavedMovies()
        
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
