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
    
    
    @State private var movieRating : Rating?
    
    @State private var showStarSlider: Bool = false
    
//    {
//
//
//        return movieRatings.searchForRatingsFromMovie(id: movieID)
//
////        let x = movieRatings.getRatings(id: movieID)
////        isFavorite = x.isFavorite
////        return x
//    }
    
    var body: some View {
       
        
        ZStack(alignment: .center) {
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
                                MovieCard(url: URL(string: MovieStoreKey.imageURL.rawValue + posterPath), rating: movieRating)
                                    
                                    .padding(.horizontal)
                                
                                Button(action: {
                                    if let rating = movieRating {
                                        rating.isFavorite.toggle()
                                        print("oldComment: \(rating.comment ?? "isEmpty")")
                                        rating.comment = "Added Comment to rating \(movieID)"
                                        movieRatings.saveContext()
                                        print("newComment: \(rating.comment ?? "isEmpty")")
                                        print(rating)
                                    }
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
                                    //                                        .frame(width: geometry.size.width/2, height: 200, alignment: .leading)
                                    .frame(width: UIScreen.main.bounds.width/2, height: 200, alignment: .leading)
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
                                    .padding(.horizontal )
                                
                                // Rating
                                Button(action: {
                                    self.showStarSlider.toggle()
                                }, label: {
                                    StarBar(value: rating)
                                        .frame(width: UIScreen.main.bounds.width/2, height: 25 )
                                        .padding(.vertical, 4)
                                })
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
                        //                            })
                        
                        
                        
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
                            .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
                            .foregroundColor(.darkBlue)
                            .overlay(
                                Text("Advertisment").font(.title)
                                    .foregroundColor(.pGray2)
                                
                            )
                        
                        // MARK: - Suggested Movies
                        ScrollBar(type: .recommendedMovie, id: movieID)
                        
                        
                        
                        PurchaseLinkBar(movieID: movieID)
                        
                        
                        PurchaseLinkButton(movieID: movieID)
                    } // V stack
                    
                    
                    
                } // z stack
                
                
            } // scroll
            
            if showStarSlider == true {
                Button(action: {
                    self.showStarSlider = false
                }, label: {
                    RoundedRectangle(cornerRadius: 0)
                        .foregroundColor(.black)
                        .opacity(0.6)
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height)
                })
            }
            
            StarSlider(value: 0.0, width: showStarSlider ? UIScreen.main.bounds.width - 40 : 0 , height: showStarSlider ? 210 : 0) 
                .cornerRadius(12.0)
                .animation(.easeIn)
            
            
            
        } // ZStack
        .animation(.default)
        

        .onAppear() {
            
            print( "Movie ID: \(movieID)"  )
            print( "Movie Title: \(movieTitle)"  )
            print( "Movie Overview: \(movieOverview)"  )
            print( "Path: \(MovieStoreKey.imageURL.rawValue + posterPath)" ) 
            print( "GenreIDs: \(genreIDs)" )
            
            
            movieRating = movieRatings.searchForRatingsFromMovie(id: movieID) 
            movieStore.fetchPurchaseMovieLinks(id: movieID) // Makes loading Details
            
        }
        
        
    } // body
} // Movie

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(movieTitle: "Long movie title goes here ")
    }
}

