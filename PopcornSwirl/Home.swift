//
//  Home.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI
import Alamofire


struct Home: View {
    
    @ObservedObject private var genreStore = GenreStore()
    @ObservedObject var movieStore = MovieStore()
    
    
    var body: some View {
        
        // MARK: NAVLINK TEST -
//        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.vertical)
                
                ScrollView(.vertical, showsIndicators: false ) {
                    
                    // MARK: POPULAR MOVIES STACK
                    
                    VStack(spacing: 20) {
                        
                        
                        ScrollBar(type: .popularMovie)
                        
                        // MARK: UPCOMING MOVIES STACK
                        
                        ScrollBar(type: .upcomingMovie)
                        
                        
                    } // VStack
                    // MARK: NAVLINK TEST -
//                    .navigationBarTitle("Home", displayMode: .inline)
                    
                    
                    
                } // scroll
                .navigationBarBackButtonHidden(false)
            } // Z Stack
            // MARK: NAVLINK TEST -
//        } // Nav
        
        .onAppear() {
            //MARK: CoreData -
            genreStore.loadAllGenres()

//            let moviesStore = MoviesStore()
//            moviesStore.deleteAllMovie()
//
//
            
            
        }
        
    } // body
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
