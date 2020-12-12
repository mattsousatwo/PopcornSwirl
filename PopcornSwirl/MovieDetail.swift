//
//  MovieDetail.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MovieDetail: View {
    
    @State private var showDesription: Bool = false
    
    @ObservedObject var movieStore = MovieStore()
    
    var movieID = Int()
    var movieTitle = String()
//    var genre = String()
    var movieOverview = String()
    var posterPath = String()
    
    var body: some View {
       
 
        GeometryReader { geometry in
            ScrollView {
                
                ZStack {
                        VStack(alignment: .leading) {
                            HStack(alignment: .bottom) {
                                // Movie Poster
                                Poster(urlString: movieStore.imageURL + posterPath, title: movieTitle)
                                    .padding()
                                VStack(alignment: .leading, spacing: 10) {
                                    // Movie Title
                                    Text(movieTitle).font(.system(.largeTitle))
                                    // Genre
                                    Text("Action / Adventure").foregroundColor(.gray)
                                    // Rating
                                    StarBar(value: 4.8)
                                        .padding(.vertical, 4)
                                }
                            }
                            
                            // Description

                            Button(action: {
                                self.showDesription.toggle()
                            }) {
                                switch showDesription{
                                case true: // show
                                    
                                    Text("A really long description of the movie would go here. Probably 3 - 4 lines of text.")
                                case false: // hide
                                    Text(movieOverview)
                                }
                            }
                            .foregroundColor(.black)
                            .animation(.default)
                            .padding()

                            
                            
                            // Actors scroll view
                            HStack {
                                Text("Actors").font(.system(.title2)).bold()
                                Spacer()
                                Text("See All")
                            }
                                .padding(.horizontal)
                                .padding(.top)
                            
                            ScrollView(.horizontal, showsIndicators:  false) {
                                HStack {

                                    ForEach(0..<movieStore.movieCast.count, id: \.self ) { i in
                                    
                                        ActorCard2(color: .coral,
                                                  image: Image(systemName: "person.fill"),
                                                  width: 100,
                                                  height: 200,
                                                  title: movieStore.movieCast[i].name,
                                                  subtitle: movieStore.movieCast[i].character)
                                            .padding(.horizontal, 7).padding(.vertical, 5)
                                    
                                    }
                                }
                            } .padding() // actors scroll view
                            
                            
                            RoundedRectangle(cornerRadius: 12)
                                .padding(.horizontal)
                                .frame(width: geometry.size.width, height: 100, alignment: .center)
                                .foregroundColor(.darkBlue)
                                .overlay(
                                    Text("Advertisment").font(.title)
                                        .foregroundColor(.pGray2)
                                    
                                )
                            // MARK: - Suggested Movies
                            HStack {
                                Text("Suggested Movies").font(.system(.title2)).bold()
                                Spacer()
                                Text("See All")
                            }
                                .padding(.horizontal)
                                .padding(.top)
                            
                            ScrollView(.horizontal, showsIndicators:  false) {
                                HStack {
                                    ForEach(0..<movieStore.recommendedMovies.count, id: \.self ) { i in
                                        if movieStore.recommendedMovies[i].poster_path != nil {
                                            NavigationLink(destination: MovieDetail(
                                                            movieID: movieStore.recommendedMovies[i].id,
                                                            movieTitle: movieStore.recommendedMovies[i].title,
                                                            movieOverview: movieStore.recommendedMovies[i].overview,
                                                            posterPath: movieStore.recommendedMovies[i].poster_path ?? "" )) {
                                                // link label
                                                Poster(urlString: movieStore.imageURL + (movieStore.recommendedMovies[i].poster_path ?? ""), title: movieStore.recommendedMovies[i].title)
                                            } // Nav Label
                                        } // if poster != nil
                                    } // ForEach
                                } .padding()  // HS
                            } // actors scroll view
                            
                            
                            
                        }
                        
                        
                            
                } // z stack
                    

                    .overlay(
                        
                            // Trailer button
                        HStack {
 
                            WatchedButton()
                            BookmarkButton()
                            
                            PlayButton(pressed: false)
                                
                            

                        }
                        .padding(.vertical)
                        .padding(.horizontal, 5)
//                            .offset(x: -10,
//                                    y: -145)
                            , alignment: .topTrailing)
                        
                
                
                
            } // scroll
            
            
        } // geo
        
        
        .background(Color.pGray)
        .edgesIgnoringSafeArea(.bottom)
        
        .navigationBarBackButtonHidden(false )
        
        
        .onAppear() {
            
            print( "Movie ID: \(movieID)"  )
            print( "Movie Title: \(movieTitle)"  )
            print( "Movie Overview: \(movieOverview)"  )
            print( "Path: \(movieStore.imageURL + posterPath)" )
            
            movieStore.fetchMovieCreditsForMovie(id: movieID)
            movieStore.fetchRecommendedMoviesForMovie(id: movieID)
            
            movieStore.fetchResultsForMovie(query: "croft")
        }
        
        
    } // body
} // Movie

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail()
    }
}
