//
//  MainTabView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var movieStore = MovieStore()
    
    
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
                
            } // TabView
            .navigationTitle("Popcorn Swirl")
            .navigationBarTitleDisplayMode(.inline)
        }



    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
