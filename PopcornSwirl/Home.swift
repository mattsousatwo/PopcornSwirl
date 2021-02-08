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
    
    var movieRatings = MovieRatingStore()
    @ObservedObject private var genreStore = GenreStore()
    @ObservedObject var movieStore = MovieStore()
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.vertical)
                
                ScrollView(.vertical, showsIndicators: false ) {
                    
                    // MARK: - POPULAR MOVIES STACK
                    
                    VStack(spacing: 20) {
                        
                        
                        ScrollBar(type: .popularMovie)
                        
                        
                        // MARK: - UPCOMING MOVIES STACK
                        
                        ScrollBar(type: .upcommingMovie)
                        
                        
                    } // VStack
                    
                    .navigationBarTitle("Home", displayMode: .inline)
                    
                } // scroll
                
            } // Z Stack
            
        } // Nav
        
        .onAppear() {
            
            // TMDB
            movieStore.getGenres()
//            movieStore.decodePopularMoviesAsString()
            
            
            //MARK: CoreData -
            genreStore.loadAllGenres()
            
            
            let movieStore = MoviesStore()
            movieStore.deleteAllMovie()
            
            
            
            
            
            let actorsStore = ActorsStore()
            actorsStore.deleteAllSavedActors()
            
            let castStore = CastStore()
            castStore.deleteAll()
            
            
            // MARK: Can put below in a test -
            
//        movieRatings.deleteAllMovieRatings()
            movieRatings.fetchAllRatings()
            let search = movieRatings.searchForRatingsFromMovie(id: 1)
            
            search.comment = "Comment @ 11:12AM"
            search.rating = 5.0
            search.isFavorite = true
            search.type = MovieRatingType.movie.rawValue
            movieRatings.saveContext()
            
            
            
            
            
        }
        
    } // body
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
