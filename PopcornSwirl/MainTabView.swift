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
        
        TabView {
            
            Home()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Home")
                }
            
            
            SearchMovie(searchTag: "")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                    
                }
            
            SavedMovies()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("Saved")
                    
                }
            
            
        
        
        }
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
