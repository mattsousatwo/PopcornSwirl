//
//  GenreBar.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/29/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct GenreBar_Previews: PreviewProvider {
    static var previews: some View {
        
            GenreBar(genres: [12, 50]).previewLayout(.sizeThatFits)
            
            
        
    }
}


struct GenreBar: View {
    
    @ObservedObject private var movie = MovieStore()
    
    @ObservedObject private var genreStore = GenreStore()
    
    var genres: [Int]
    
    private var genreList: [String] {
        
//        movie.getGenres()
        
        var genreNames: [String] = []
//        genreNames = movie.extractGenres(from: genres)
        
        genreNames = genreStore.extractGenreFrom(ids: genres)
        return genreNames
    }
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(genreList, id: \.self) { genre in
                    
                    
                    RoundedRectangle(cornerRadius: 10)
                        .opacity(0.6)
                        .foregroundColor(.lightBlue)
                        .frame(width: 100,
                            height: 40)
                        .shadow(radius: 3)
                        .overlay(Text(genre).bold().foregroundColor(.pGray3).opacity(0.8))
                    
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                
            }
        }
        .padding(.horizontal)
        
    }
    
    
}
