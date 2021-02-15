//
//  SavedMovies.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/24/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SavedMovies: View {
    
    @ObservedObject var movieStore = MoviesStore()
    
    @State private var viewType: SavedMoviesViewType = .favorite
    
    private var viewOptions: [SavedMoviesViewType] = [.favorite, .watched]
    
    private var favoriteMovies: [[Movie]] {
        if movieStore.favoriteMovies.isEmpty {
            movieStore.fetchAllFavoriteMovies()
        }
        var movieArray: [[Movie]] = []
        let dividedCount = movieStore.favoriteMovies.count / 2
        if dividedCount >= 1 {
            movieArray = movieStore.favoriteMovies.divided(into: 2)
        }
        return movieArray
    }
    
    private var watchedMovies: [[Movie]] {
        if movieStore.watchedMovies.isEmpty {
            movieStore.fetchAllWatchedMovies()
        }
        var movieArray: [[Movie]] = []
        let dividedCount = movieStore.watchedMovies.count / 2
        if dividedCount >= 1 {
            movieArray = movieStore.watchedMovies.divided(into: 2)
        }
        return movieArray
    }
    
    var body: some View {
        
        ZStack(alignment: .center) {
            // Background
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .vertical)
            
            
            VStack {
                HStack {
                    Picker(selection: $viewType,
                           label: Text("View Type"),
                           content: {
                            ForEach(viewOptions, id: \.self) {
                                Text($0.rawValue)
                            }
                           }).pickerStyle(SegmentedPickerStyle())
                }
                .padding()
            }
            
            
        } // Z
        
        .navigationTitle(Text("Saved Movies"))
        
    } // Body
    
} // SavedMovies()

struct SavedMovies_Previews: PreviewProvider {
    static var previews: some View {
        SavedMovies()
        
        
    }
}

enum SavedMoviesViewType: String, Hashable  {
    case favorite = "Favorite"
    case watched = "Watched"
}
