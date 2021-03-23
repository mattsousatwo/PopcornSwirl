//
//  MovieDetail.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI
import Combine

struct MovieDetail: View, Equatable {
        
    
    // Equatable
    static func == (lhs: MovieDetail, rhs: MovieDetail) -> Bool {
        return lhs.movie == rhs.movie
    }
    
    // TMDB
    @ObservedObject private var movieStore = MovieStore()
    
    // CoreData
    @ObservedObject private var movieCD = MoviesStore()
    
    private var movie: Movie { 
        return movieCD.fetchMovie(uuid: movieID)
    }
    
    // Animation
    @State private var showStarSlider: Bool = false
    @State private var showCommentBox: Bool = false
    @State private var commentText: String = ""
    
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
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        if let dateCD = movie.releaseDate {
            if let convertedDate = dateCD.convertToDate() {
                release = formatter.string(from: convertedDate)
            }
        }
        if let date = releaseDate.convertToDate() {
            release = formatter.string(from: date)
        }
        return release
    }
    
    var director: String {
        var name = ""
        if let movieDirector = movie.director {
            name = movieDirector
        } else {
            name = movieStore.director
        }
        return name
    }

    // decoded genre ids
    var genres: [String] {
        var ids: [Int] = []
        if let movieGenres = movie.genres {
            print("MovieGenres: \(movieGenres)")
            if let genreIDs = movieCD.decodeGenres(movieGenres) {
                ids = genreIDs
            }
        }

        
        let genreDict = GenreDict()
        
        let genreNames = genreDict.convertGenre(IDs: ids)

        print("GenresNames: \(genreNames), count: \(genreNames.count), ID: \(ids)")
        return genreNames
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
    
    // decoded Recommended Movies
    var reccomendedMovies: [RecommendedMovie]? {
        if let recMovies = movie.recommendedMovies {
            if let decodedMovies = movieCD.decodeReccomendedMovies(recMovies) {
                return decodedMovies
            }
        }
        return nil
    }
    
    // Display Movie poster
    func moviePoster() -> some View {
        if let poster = movie.imagePath {
            return ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + poster), movie: movie).padding(.horizontal)
        } else {
            return ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + posterPath), movie: movie).padding(.horizontal)
        }
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
    
    
    /// Button to trigger CommentView
    func commentButton() -> some View {
        Button(action: {
            self.showCommentBox.toggle()
        }) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 150, height: 40)
                .foregroundColor(.darkBlue)
                .opacity(0.6)
                .overlay(
                    Text("Comment")
                        .foregroundColor(.pGray3)
                        .opacity(0.8)
                    , alignment: .center)
        } .sheet(isPresented: $showCommentBox) {
            CommentView(movie: movie,
                        isPresented: $showCommentBox)
        }
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
                            moviePoster()
                            commentButton()
                        } // v stack

                        VStack(alignment: .leading, spacing: 10) {
                            // Movie Title
                            title()
                            // Director
                            Text("Director:").bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            Text("\(director)")
                                .foregroundColor(.pGray3)
                                .padding(.horizontal)
                            // Release Date
                            Text("Release Date:").bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            Text(moviePremire)
                                .foregroundColor(.pGray3)
                                .padding(.horizontal )
                            
                            StarBar(value: rating)
                                .frame(width: UIScreen.main.bounds.width/2, height: 25 )
                                .padding(.vertical, 4)
                            
                        }
                    }

//                    // Description
                    Text(movieOverview).lineLimit(nil)
                        .foregroundColor(.pGray3)
                        .padding(.horizontal)
                        .padding(.trailing, 8)

                    //MARK: - Genres -
                    GenreBar(genres: genres)

                    

                    ScrollBar(type: .actors, id: movieID, movieCast: movieCast).equatable()

                    HStack {
                        Spacer()
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: UIScreen.main.bounds.width - 40,
                               height: 100,
                               alignment: .center)
                        .foregroundColor(.darkBlue)
                        .overlay(
                            Text("Advertisment").font(.title)
                                .foregroundColor(.pGray2)
                        )
                        Spacer()
                    }
//                    // MARK: - Suggested Movies
                    ScrollBar(type: .recommendedMovie, id: movieID).equatable()
//
                    PurchaseLinkBar(movieID: movieID, movie: movie)
                        .padding(.bottom)
//
                } // V stack

            } // scroll


        } // ZStack
                
        
        .onAppear() {

//            genreStore.loadAllGenres()
            
            
            
            print("MovieDetail - is loading:")
            print("ShowStarSlider - MovieDetail: \(showStarSlider)")
            
            print( "Movie ID: \(movieID)"  )
            print( "Movie Title: \(movieTitle)"  )
            print( "Movie Overview: \(movieOverview)"  )
            print( "Path: \(MovieStoreKey.imageURL.rawValue + posterPath)" )
//            print( "GenreIDs: \(genres)" )
            print("MovieDetail - is loaded\n")

        }
        
        
    } // body
} // Movie


//
//struct MovieDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieDetail(movieTitle: "Long movie title goes here ")
//    }
//}

