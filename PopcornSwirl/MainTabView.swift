//
//  MainTabView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    
    
    
    var body: some View {
        // MARK: NAVLINK TEST -
        NavigationView {
            TabView {
                Home()
                    .tabItem {
                        Image(systemName: "square.grid.2x2")
                        Text("Home")
                    }.tag(0)
                
                SearchMovie(searchTag: "")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }.tag(1)

                SavedMovies()
                    .tabItem {
                        Image(systemName: "bookmark")
                        Text("Saved")
                    }.tag(2)
                
//                    .navigationViewStyle(StackNavigationViewStyle())
            } // TabView
            .navigationTitle("Popcorn Swirl")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onAppear {
            
            
            let movieStore = MovieStore()
//            let genresDict = movieStore.pullGenres()
            
            let genres = GenreStore()
            
            movieStore.pullGenresFromServer() 
//            genres.initalizeGenres()
            print("InitalizeGenres: genres.count = \(genres.genres.count)")
        }
        
        
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
