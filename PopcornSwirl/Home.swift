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
//    var movieRatings : MovieRatingStore?
    
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
                        
                    

//                    HStack {
//                        Text("Popular Movies").font(.system(.title, design: .rounded)).bold()
//                            .padding(.horizontal)
//                            .padding(.top)
//                        Spacer()
//                    } // HStack - Popular Movies Title
//                    ScrollView(.horizontal, showsIndicators:  false) {
//
//                        HStack(spacing: 15) {
//
//                            ForEach(0..<movieStore.popularMovies.count, id: \.self ) { i in
//
//                                if movieStore.popularMovies.count != 0 {
//                                    NavigationLink(destination:
//                                        MovieDetail(
//                                            movieID: movieStore.popularMovies[i].id,
//                                            movieTitle: movieStore.popularMovies[i].title,
//                                            genreIDs: movieStore.popularMovies[i].genre_ids,
//                                            movieOverview: movieStore.popularMovies[i].overview,
//                                            posterPath: movieStore.popularMovies[i].poster_path,
//                                            rating: movieStore.popularMovies[i].vote_average,
//                                            releaseDate: movieStore.popularMovies[i].release_date) ) {
//                                        RemotePoster(url: movieStore.imageURL + movieStore.popularMovies[i].poster_path)
//                                    }
//
//                                }
//                            }
//
//                        } .padding()
//
//                    } // scroll - Popular Movies

                    // MARK: - UPCOMING MOVIES STACK
                        
                        ScrollBar(type: .upcommingMovie)
                        
//                    HStack {
//                        Text("Upcoming Movies").font(.system(.title, design: .rounded)).bold()
//                            .padding(.horizontal)
//                        Spacer()
//                    }
//                    // Horizontal Scroll
//                    ScrollView(.horizontal, showsIndicators:  false) {
//                        HStack(spacing: 15) {
//                            ForEach(0..<movieStore.upcomingMovies.count, id: \.self ) { i in
//
//                                if movieStore.upcomingMovies.count != 0 {
//                                    NavigationLink(destination: MovieDetail(
//                                            movieID: movieStore.upcomingMovies[i].id,
//                                            movieTitle: movieStore.upcomingMovies[i].title,
//                                            genreIDs: movieStore.upcomingMovies[i].genre_ids,
//                                            movieOverview: movieStore.upcomingMovies[i].overview,
//                                            posterPath: (movieStore.upcomingMovies[i].poster_path ?? ""),
//                                            rating: movieStore.upcomingMovies[i].vote_average,
//                                            releaseDate: movieStore.upcomingMovies[i].release_date)
//                                    ) {
//                                        RemotePoster(url: movieStore.imageURL + (movieStore.upcomingMovies[i].poster_path ?? ""))
////                                            Poster(urlString: movieStore.imageURL + (movieStore.upcomingMovies[i].poster_path ?? ""),
////                                                   title: movieStore.upcomingMovies[i].title)
//                                    }
//
//                                }
//
//                            }
//
//                        }.padding()
//
//                    } // scroll - Upcoming Movies
//
//
                    // MARK: - UPCOMING MOVIES STACK - end
                        
                        
                } // VStack

                    .navigationBarTitle("Home", displayMode: .inline)

            } // scroll
            
        } // Z Stack

    } // Nav
        
    .onAppear() {
        
        // TMDB
        movieStore.getGenres()
        movieStore.fetchPopularMovies()
        movieStore.fetchUpcomingMovies()
        
        // CoreData
        genreStore.fetchAllGenres()
        
        
        
        
//        movieRatings.deleteAllMovieRatings()
            movieRatings.fetchAllRatings()
        guard let s = movieRatings.fetchRatingsForMovie(id: 1) else { return }
        
        
        
        let actorsStore = ActorsStore()
        actorsStore.deleteAllSavedActors() 
        
        let castStore = CastStore()
        castStore.deleteAll()
        
        
        
    }
        
    } // body
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
