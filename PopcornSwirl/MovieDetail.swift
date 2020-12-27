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
    var genreIDs = [Int]()
    
    private var genres: [String] {
        var genreArray: [String] = []
        print("T1: genreArray = \(genreArray.count)")
        
        for id in genreIDs {
            for genre in movieStore.genreArray {
             
                if genre.id == id {
                    print("Confirmed: \(genre.id), \(genre.name)")
                    genreArray.append(genre.name)
                } else {
                    genreArray.append("Object")
                }
                
            }
        }
        
        
        
        return genreArray
    }
    
    
    var movieOverview = String()
    var posterPath = String()
    var rating = Double()

    
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
                                RemotePoster(url: movieStore.imageURL + posterPath)
                                    
                                    .overlay(
                                        Button(action: {
                                            
                                        }, label: {
                                            Image(systemName: "heart") // CoreData.isFavorite ? "heart.fill" : "heart"
                                                .frame(width: 35, height: 35)
                                                .padding()
                                                .foregroundColor(.lightBlue )
                                        })
                                        , alignment: .bottomTrailing)

                                    .padding()
                                
                                    Button(action: {
                                        print("add Comment")
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
                                    Text(movieTitle).font(.system(.largeTitle)).multilineTextAlignment(.leading).lineLimit(3).frame(width: geometry.size.width/2, height: 200, alignment: .topLeading).padding(.top).foregroundColor(.white)
                                    Spacer()
                                     
                                    // Rating
                                    StarBar(value: rating)
                                        .frame(width: geometry.size.width / 2, height: 25 )
                                        .padding(.vertical, 4)
                                }
                            }
                            
                            // Description
                            Text(movieOverview)
                                .foregroundColor(.black)
                                .padding()

                            GenreBar(genres: genreIDs)
                            
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

                                    if movieStore.actorImageProfiles.count != 0  {
                                        
                                        ForEach(0..<movieStore.actorImageProfiles.count, id: \.self ) { i in
                                        
                                            if i <= 9 {

                                                if let actorImagePath = movieStore.actorImageProfiles[movieStore.movieCast[i].id] {
                                                    
                                                    NavigationLink(destination:
                                                        ActorDetail(image: movieStore.imageURL + actorImagePath,
                                                                    actorID: movieStore.movieCast[i].id,
                                                                    name: movieStore.movieCast[i].name,
                                                                    isFavorite: false)
                                                    ) {
                                                    
                                                        RemoteActor(url: movieStore.imageURL + actorImagePath,
                                                                    name: movieStore.movieCast[i].name,
                                                                    subtitle: movieStore.movieCast[i].character,
                                                                    isFavorite: false)
                                                            
                                                    } // nav link
                                                    
                                                } // if let
                                            } // if actor index is less than 9
                                        } // ForEach
                                    } // if movieCast != 0
                                }   // HSTack
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
                                                            posterPath: movieStore.recommendedMovies[i].poster_path ?? "",
                                                            rating: movieStore.recommendedMovies[i].vote_average))
                                            {
                                                // link label
                                                RemotePoster(url: movieStore.imageURL + (movieStore.recommendedMovies[i].poster_path ?? ""))
                                                
//                                                MoviePoster(urlString: movieStore.imageURL + (movieStore.recommendedMovies[i].poster_path ?? ""))
                                            } // Nav Label
                                        } // if poster != nil
                                    } // ForEach
                                } .padding()  // HS
                            } // suggested movie scroll view
                        } // V stack
                        
                        
                            
                } // z stack

                    
                } // scroll
            
            } // ZStack
            
        } // geo
        
        
        .background(Color.pGray)
//        .edgesIgnoringSafeArea(.bottom)
        
        .navigationBarBackButtonHidden(false )
        
        
        .onAppear() {
            
            print( "Movie ID: \(movieID)"  )
            print( "Movie Title: \(movieTitle)"  )
            print( "Movie Overview: \(movieOverview)"  )
            print( "Path: \(movieStore.imageURL + posterPath)" )
            print( "GenreIDs: \(genreIDs)" )
            
            
            
            movieStore.fetchMovieCreditsForMovie(id: movieID)
            
            movieStore.fetchRecommendedMoviesForMovie(id: movieID)
            
        }
        
        
    } // body
} // Movie

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(movieTitle: "Long movie title goes here ")
    }
}
