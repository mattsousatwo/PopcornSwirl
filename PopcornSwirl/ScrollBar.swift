//
//  ScrollBar.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/6/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI


enum ScrollBarType: String  {
    case popularMovie = "Popular"
    case upcommingMovie = "Upcomming"
    case recommendedMovie = "Recommended" // Need to access movie ID
    case actors = "Actors" // Need to access movie ID
    // case tv = "TV"
}


struct ScrollBar: View {
    
    @ObservedObject var movieStore = MovieStore()
    
    var type: ScrollBarType
    
    var id: Int = 0
    
    var body: some View {
        
        VStack(spacing: 10) {
            HStack {
                
                
                Text(type.rawValue).font(.system(.title, design: .rounded)).bold()
                    .foregroundColor(.pGray3)
                    .padding()
                
                Spacer()
                
                // SeeAll Button
                if type == .recommendedMovie {
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
                    
                    bar(type: type, id: id)

                } .padding() // HStack
  
            } // ScrollView - Content

        } // VStack - end
        
        
        
        
    }
    
}


struct bar: View {
    
    
    var type: ScrollBarType
    
    var id: Int // used to fetch recomended movies
    
    var popularMovies : [PopMovie] {
        return movieStore.extractPopularMovies()
    }
    
    private var recommendedMovies: [RecommendedMovie] {
        return movieStore.extractRecomendedMovies(id: id)
    }
    
    private var upcomingMovies: [UpcomingMovie] {
        return movieStore.extractUpcomingMovies()
    }
    
    private var cast: [MovieCast] {
        return movieStore.extractMovieCast(id: id)
    }
    
    private var actorImages: [Int : String ] {
        return movieStore.extractActorImageProfiles(id: id)
    }

    
    
    
    @ObservedObject var movieStore = MovieStore()
    
    
    var body: some View {
        
        switch type {
        case .actors:
            if actorImages.count != 0 {
                ForEach(0..<actorImages.count, id: \.self) { i in
                    if i <= 9 {
                        if let imagePath = actorImages[ cast[i].id ] {
                            
                            NavigationLink(
                                destination: ActorDetail(image: movieStore.imageURL + imagePath,
                                                         actorID: cast[i].id,
                                                         name: cast[i].name,
                                                         isFavorite: false),   // Get Coredata Rating
                                label: {
                                    RemoteActor(url: movieStore.imageURL + imagePath,
                                                name: cast[i].name,
                                                subtitle: cast[i].character,
                                                isFavorite: false)
                                })
                            
                        } // imagePath
                    } // i <= 9
                } // for
                .animation(.default)
            } // if
            
        case .popularMovie:
            
            // Changed to closure array instead of movieStore property 
            
            ForEach(0..<popularMovies.count, id: \.self) { i in
                if popularMovies.count != 0 {
                    
                    NavigationLink(destination: MovieDetail(movieID: popularMovies[i].id,
                                                            movieTitle: popularMovies[i].title,
                                                            genreIDs: popularMovies[i].genre_ids,
                                                            movieOverview: popularMovies[i].overview,
                                                            posterPath: popularMovies[i].poster_path,
                                                            rating: popularMovies[i].vote_average,
                                                            releaseDate: popularMovies[i].release_date)  ) {
                        // Label
                        RemotePoster(url: movieStore.imageURL + popularMovies[i].poster_path)
                    }
                }
            }
            
            .animation(.default)
        case .upcommingMovie:
            ForEach(0..<upcomingMovies.count, id: \.self) { i in
                if upcomingMovies.count != 0 {
                    
                    NavigationLink(destination: MovieDetail(movieID: upcomingMovies[i].id,
                                                            movieTitle: upcomingMovies[i].title,
                                                            genreIDs: upcomingMovies[i].genre_ids,
                                                            movieOverview: upcomingMovies[i].overview,
                                                            posterPath: upcomingMovies[i].poster_path ?? "",
                                                            rating: upcomingMovies[i].vote_average,
                                                            releaseDate: upcomingMovies[i].release_date)  ) {
                        // Label
                        RemotePoster(url: movieStore.imageURL + (upcomingMovies[i].poster_path ?? "") )
                    }
                }
            }
            .animation(.default)
        case .recommendedMovie:
            ForEach(0..<recommendedMovies.count, id: \.self) { i in
                if recommendedMovies.count != 0 {
                    
                    NavigationLink(destination: MovieDetail(movieID: recommendedMovies[i].id,
                                                            movieTitle: recommendedMovies[i].title,
                                                            genreIDs: recommendedMovies[i].genre_ids,
                                                            movieOverview: recommendedMovies[i].overview,
                                                            posterPath: recommendedMovies[i].poster_path ?? "",
                                                            rating: recommendedMovies[i].vote_average,
                                                            releaseDate: recommendedMovies[i].release_date)  ) {
                        // Label
                        RemotePoster(url: movieStore.imageURL + (recommendedMovies[i].poster_path ?? "") )
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



