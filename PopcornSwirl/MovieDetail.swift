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
    
    // TMDB
    @ObservedObject private var movieStore = MovieStore()
    
    
    // CoreData
    @ObservedObject private var movieCD = MoviesStore()
    private var movie: Movie { 
        return movieCD.fetchMovie(uuid: movieID)
    }
    
    // Animation
    @State private var showStarSlider: Bool = false
    @State private var showFullOverview = false
    @State private var showDesription: Bool = false
    
    // MovieDetail Properties
    var movieID = Int()
    var movieTitle = String()
    var genreIDs = [Int]()
    var movieOverview = String()
    var posterPath = String()
    var rating = Double()
    var releaseDate = String()
    
    var moviePremire: String {
        var release = ""
        if let date = releaseDate.convertToDate() {
            release = date.movieDate()
        }
        return release
    }
    
    // decoded genre ids 
    var genres: [Int] {
        var ids: [Int] = []
        if let movieGenres = movie.genres {
            print("MovieGenres: \(movieGenres)")
            if let genreIDs = movieCD.decodeGenres(movieGenres) {
                ids = genreIDs
            }
        }
        print("Genres: \(ids)")
        return ids
    }
    
    // decoded movie cast
    var movieCast: [MovieCast]? {
        if let movieCastString = movie.cast {
            if let decodedMovieCast = movieCD.decodeCast(movieCastString) {
                return decodedMovieCast
            }
        }
        return nil
    }
    
    // Text view of movie title
    func title() -> some View {
        var title = ""
        if let movieTitle = movie.title {
            title = movieTitle
        } else {
            title = movieTitle
        }
        
        return Text(title).font(.system(.largeTitle)).bold().multilineTextAlignment(.leading).lineLimit(3)
            .frame(width: UIScreen.main.bounds.width/2, height: 150, alignment: .leading).padding(.top).padding(.horizontal).foregroundColor(.white)
    }
    
    // Comment Button
    func commentButton() -> some View {
        return Button(action: {
            movie.isFavorite.toggle()
            print("oldComment: \(movie.comment ?? "isEmpty")")
            movie.comment = "New comment @ \(Date().time() )"
            movieCD.saveContext()
            print("newComment: \(movie.comment ?? "isEmpty")")
            print(movie)
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
    }
    
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            // Background
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .vertical)
            
            // Content
            ScrollView {
                
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        
                        VStack {
                            // Movie Poster
                            if let poster = movie.imagePath {
                                ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + poster), movie: movie)
                                    .padding(.horizontal)
                            } else {
                                ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + posterPath), movie: movie)
                            }
                            
                            
                            commentButton()
                            
                            
                            
                        } // v stack
                        
                        VStack(alignment: .leading, spacing: 10) {
                            // Movie Title
                            title()
                            
                            
                            // Director
                            Text("Director:").bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            Text("\(movie.director ?? "")")
                                .foregroundColor(.pGray3)
                                .padding(.horizontal)
                            // Release Date
                            Text("Release Date:").bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            Text(moviePremire)
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
                    Text(movieOverview).lineLimit(nil)
                        .foregroundColor(.pGray3)
                        .padding(.horizontal)
                        .padding(.trailing, 8)
                    
                    
                    
                    // Genres
                    //                    GenreBar(genres: genreIDs)
                    GenreBar(genres: genres)
                    
                    // MARK: - Actors Scroll
                    
                    ScrollBar(type: .actors, id: movieID, movieCast: movieCast)
                    
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
                    
                    PurchaseLinkBar(movieID: movieID, movie: movie)
                        .padding(.bottom)
                    
                } // V stack
                
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
            
            StarSlider(movie: movie, value: 0.0, width: showStarSlider ? UIScreen.main.bounds.width - 40 : 0 , height: showStarSlider ? 210 : 0)
                .cornerRadius(12.0)
                .animation(.easeIn)
            
            
            
        } // ZStack
        
        
                
        
        .onAppear() {
            
            print( "Movie ID: \(movieID)"  )
            print( "Movie Title: \(movieTitle)"  )
            print( "Movie Overview: \(movieOverview)"  )
            print( "Path: \(MovieStoreKey.imageURL.rawValue + posterPath)" )
            print( "GenreIDs: \(genres)" )
            
            
        }
        
        
    } // body
} // Movie


//
//struct MovieDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetail(movieTitle: "Long movie title goes here ")
//    }
//}

