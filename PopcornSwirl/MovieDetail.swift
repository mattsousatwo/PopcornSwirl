//
//  MovieDetail.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI
import Combine

struct MovieDetail: View {
    
    @State private var showDesription: Bool = false
    
    @ObservedObject private var movieStore = MovieStore()
    
    var movieID = Int()
    var movieTitle = String()
    var genreIDs = [Int]()
    var movieOverview = String()
    var posterPath = String()
    var rating = Double()
    var releaseDate = String()

    var movieRatings = MovieRatingStore()
    
    
    @State private var isFavorite: Bool = false
    
    @State private var showFullOverview = false
    
    
    private var movieRating : MovieRating {
        
        let x = movieRatings.getRatings(id: movieID)
        isFavorite = x.isFavorite
    
        return x
    }
    
    var body: some View {
       
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(edges: .vertical)
                // Content
                ScrollView {
                
                ZStack {
                        VStack(alignment: .leading) {
                            HStack(alignment: .bottom) {
                                
                                VStack {
                                // Movie Poster
//                                RemotePoster(url: movieStore.imageURL + posterPath)
                                    MovieCard(url: URL(string: movieStore.imageURL + posterPath) )

                                    .padding()
                                
                                    Button(action: {
                                        print("add Comment")
                                        
                                        movieRating.comment = "Added Comment to rating \(movieID)"
                                        movieRatings.saveContext()
                                    }, label: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 150, height: 40)
                                            .foregroundColor(.darkBlue)
                                            .opacity(0.6)
                                            .overlay(
                                                Text("Comment")
                                                    .foregroundColor(.pGray3)
                                                    .opacity(0.8)
                                            )
                                            
                                    })

                                    
                                } // v stack
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    // Movie Title
                                    Text(movieTitle).font(.system(.largeTitle)).bold().multilineTextAlignment(.leading).lineLimit(3)
                                        .frame(width: geometry.size.width/2, height: 200, alignment: .leading)
                                        .padding(.top).padding(.horizontal)
                                        .foregroundColor(.white)
                                    
                                    
                                    // Director
                                    Text("Director:").bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    Text("\(movieStore.director)")
                                        .foregroundColor(.pGray3)
                                        .padding(.horizontal)
                                    // Release Date
                                    Text("Release Date:").bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    Text(releaseDate)
                                        .foregroundColor(.pGray3)
                                        .padding(.horizontal)
                                    
                                    // Rating
                                    StarBar(value: rating)
                                        .frame(width: geometry.size.width / 2, height: 25 )
                                        .padding(.vertical, 4)
                                }
                            }
                            
                            // Description
                            
//
//                            Button(action: {
//                                self.showFullOverview.toggle()
//
//                            }, label: {
//                                Text(movieOverview).lineLimit(showFullOverview ? nil : 6 )
//                                    .foregroundColor(.pGray3)
//                                    .padding(.horizontal)
//                                    .padding(.trailing, 8)
//                            })657l//
                    
                    

                            Text(movieOverview).lineLimit(nil)
                                .foregroundColor(.pGray3)
                                .padding(.horizontal)
                                .padding(.trailing, 8)
                            


                            // Genres
                            GenreBar(genres: genreIDs)
                            
                            // MARK: - Actors Scroll
                            
                            ScrollBar(type: .actors, id: movieID)
                            
                            // Actors Scroll
                            
                            
                            
                            RoundedRectangle(cornerRadius: 12)
                                .padding(.horizontal)
                                .frame(width: geometry.size.width, height: 100, alignment: .center)
                                .foregroundColor(.darkBlue)
                                .overlay(
                                    Text("Advertisment").font(.title)
                                        .foregroundColor(.pGray2)
                                    
                                )
                            
                            // MARK: - Suggested Movies
                            ScrollBar(type: .recommendedMovie, id: movieID)
                            
                        } // V stack
                        
                        
                            
                } // z stack

                    
                } // scroll
            
            } // ZStack
            .animation(.default)
        } // geo
        
        
        .background(Color.pGray)

        

        
        
        .onAppear() {
            
            print( "Movie ID: \(movieID)"  )
            print( "Movie Title: \(movieTitle)"  )
            print( "Movie Overview: \(movieOverview)"  )
            print( "Path: \(movieStore.imageURL + posterPath)" )
            print( "GenreIDs: \(genreIDs)" )
            
            

//            movieStore.fetchPurchaseMovieLinks(id: movieID) // Makes loading Details
            
        }
        
        
    } // body
} // Movie

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(movieTitle: "Long movie title goes here ")
    }
}

