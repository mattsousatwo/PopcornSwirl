//
//  ScrollBar.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI


enum ScrollBarType {
    case popularMovie, upcommingMovie, reccomendedMovie, actors
}


struct ScrollBar: View {
    
    @ObservedObject var movieStore = MovieStore()
    
    var type: ScrollBarType
    
    var maxCardCount = 10
    
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                
                // Title
                switch type {
                    case .popularMovie:
                        Text("Popular Movies").font(.system(.title, design: .rounded)).bold()
                            .padding()
                    case .upcommingMovie:
                        Text("Upcommming Movies").font(.system(.title, design: .rounded)).bold()
                            .padding()
                    case .reccomendedMovie:
                        Text("Reccomended").font(.system(.title, design: .rounded)).bold()
                            .padding()
                    case .actors:
                        Text("Actors").font(.system(.title, design: .rounded)).bold()
                            .padding()
                }
                
                Spacer()
                
                // SeeAll Button
                if type == .reccomendedMovie {
                    if movieStore.recommendedMovies.count >= 9 {
                        Button(action: {
                            print("See All Reccomended Movies")
                        }, label: {
                            Text("See All")
                                .foregroundColor(.pGray3)
                                .padding()
                        })
                    }
                } else if type == .actors {
                    if movieStore.actorImageProfiles.count >= 9 {
                        Button(action: {
                            print("See All Actors")
                        }, label: {
                            Text("See All")
                                .foregroundColor(.pGray3)
                                .padding()
                        })
                    }
                }

            
            } // HStack - Title, SeeAll Button
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 15) {
                    
                    bar(type: type)

                } .padding() // HStack
  
            } // ScrollView - Content

        } // VStack
        
        
        
        
    }
    
}


struct bar: View {
    
    
    private var popMovies : [PopMovie] {
        return movieStore.extractPopularMovies()
    }
    
    @ObservedObject var movieStore = MovieStore()
    var type: ScrollBarType
    
    var body: some View {
        
        switch type {
        case .actors:
            if movieStore.actorImageProfiles.count != 0 {
                ForEach(0..<movieStore.actorImageProfiles.count, id: \.self) { i in
                    if i <= 9 {
                        if let imagePath = movieStore.actorImageProfiles[ movieStore.movieCast[i].id ] {
                            
                            NavigationLink(
                                destination: ActorDetail(image: movieStore.imageURL + imagePath,
                                                         actorID: movieStore.movieCast[i].id,
                                                         name: movieStore.movieCast[i].name,
                                                         isFavorite: false),   // Get Coredata Rating
                                label: {
                                    RemoteActor(url: movieStore.imageURL + imagePath,
                                                name: movieStore.movieCast[i].name,
                                                subtitle: movieStore.movieCast[i].character,
                                                isFavorite: false)
                                })
                            
                        } // imagePath
                    } // i <= 9
                } // for
                .animation(.default)
            } // if
            
        case .popularMovie:
            
            // Changed to closure array instead of movieStore property 
            
            ForEach(0..<popMovies.count, id: \.self) { i in
                if popMovies.count != 0 {
                    
                    NavigationLink(destination: MovieDetail(movieID: popMovies[i].id,
                                                            movieTitle: popMovies[i].title,
                                                            genreIDs: popMovies[i].genre_ids,
                                                            movieOverview: popMovies[i].overview,
                                                            posterPath: popMovies[i].poster_path,
                                                            rating: popMovies[i].vote_average,
                                                            releaseDate: popMovies[i].release_date)  ) {
                        // Label
                        RemotePoster(url: movieStore.imageURL + popMovies[i].poster_path)
                    }
                }
            }
            
            .animation(.default)
        case .upcommingMovie:
            ForEach(0..<movieStore.upcomingMovies.count, id: \.self) { i in
                if movieStore.upcomingMovies.count != 0 {
                    
                    NavigationLink(destination: MovieDetail(movieID: movieStore.upcomingMovies[i].id,
                                                            movieTitle: movieStore.upcomingMovies[i].title,
                                                            genreIDs: movieStore.upcomingMovies[i].genre_ids,
                                                            movieOverview: movieStore.upcomingMovies[i].overview,
                                                            posterPath: movieStore.upcomingMovies[i].poster_path ?? "",
                                                            rating: movieStore.upcomingMovies[i].vote_average,
                                                            releaseDate: movieStore.upcomingMovies[i].release_date)  ) {
                        // Label
                        RemotePoster(url: movieStore.imageURL + (movieStore.upcomingMovies[i].poster_path ?? "") )
                    }
                }
            }
            .animation(.default)
        case .reccomendedMovie:
            ForEach(0..<movieStore.recommendedMovies.count, id: \.self) { i in
                if movieStore.recommendedMovies.count != 0 {
                    
                    NavigationLink(destination: MovieDetail(movieID: movieStore.recommendedMovies[i].id,
                                                            movieTitle: movieStore.recommendedMovies[i].title,
                                                            genreIDs: movieStore.recommendedMovies[i].genre_ids,
                                                            movieOverview: movieStore.recommendedMovies[i].overview,
                                                            posterPath: movieStore.recommendedMovies[i].poster_path ?? "",
                                                            rating: movieStore.recommendedMovies[i].vote_average,
                                                            releaseDate: movieStore.recommendedMovies[i].release_date)  ) {
                        // Label
                        RemotePoster(url: movieStore.imageURL + (movieStore.recommendedMovies[i].poster_path ?? "") )
                    }
                }
            }
            .animation(.default)
        } // switch
        
    }
    
    
}

struct ScrollBar_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            
            ScrollBar(type: .popularMovie)

        }.previewLayout(.sizeThatFits)
    }
}



