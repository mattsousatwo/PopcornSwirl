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
    
    @ObservedObject private var genreStore = GenreStore()
    @ObservedObject var movieStore = MovieStore()
    @ObservedObject var movieCD = MoviesStore()
    
    
    @State var presentModal: Bool = false
    
    var body: some View {
        
        // MARK: NAVLINK TEST -
//        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.vertical)
                
                ScrollView(.vertical, showsIndicators: false ) {
                    
                    // MARK: POPULAR MOVIES STACK
                    
                    VStack(spacing: 20) {
              
                        
                        ScrollBar(type: .popularMovie)
                        
                        
                        
                        let tMDBMovies = movieStore.extractPopularMovies()
    
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                
                                if tMDBMovies.count != 0 {
                                    ForEach(0..<tMDBMovies.count, id: \.self) { i in
                                        
                                        let movie = movieCD.fetchMovie(uuid: tMDBMovies[i].id)
                                        
                                        NavigationLink(destination:
//                                                        MovieDetail(movieID: tMDBMovies[i].id,
//                                                      movieTitle: tMDBMovies[i].title,
//                                                      genreIDs: tMDBMovies[i].genre_ids,
//                                                      movieOverview: tMDBMovies[i].overview,
//                                                      posterPath: tMDBMovies[i].poster_path,
//                                                      rating: tMDBMovies[i].vote_average,
//                                                      releaseDate: tMDBMovies[i].release_date).equatable()
                                        
                                                        ActorDetail(image: "ImagePath",
                                                                                                actorID: 12,
                                                                                                name: "TEST NAME",
                                                                                                isFavorite: false)
                                        ) {
                                            
                                            ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + tMDBMovies[i].poster_path),
                                                      movie: movie)
                                            
                                        }
                                            .animation(.default)
                                            .onAppear {
                                                if let genresString = movieCD.encodeGenres(tMDBMovies[i].genre_ids) {
                                                    movie.update(title: tMDBMovies[i].title,
                                                                 overview: tMDBMovies[i].overview,
                                                                 imagePath: tMDBMovies[i].poster_path,
                                                                 genres: genresString,
                                                                 releaseDate: tMDBMovies[i].release_date,
                                                                 voteAverage: tMDBMovies[i].vote_average)
                                                }
                                            }
                                    }
                                }
                                
                            }.padding()
                        }
                        
                        
                        
                        
                        // MARK: navlink test
                        
                        NavigationLink(destination: ActorDetail(image: "ImagePath",
                                                                actorID: 12,
                                                                name: "TEST NAME",
                                                                isFavorite: false),
                                                                
                                       label: {
                                        Text("Navigate")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(Color.green)
                                            .cornerRadius(12)
                                            
                                            
                                       })

                        
                        
                        
                        // MARK: UPCOMING MOVIES STACK
                        
                        ScrollBar(type: .upcomingMovie)
                        
                        
                    } // VStack
                    // MARK: NAVLINK TEST -
                    .navigationBarTitle("Home", displayMode: .inline)
                    
                    
                    
                } // scroll
                .navigationBarBackButtonHidden(false)
            } // Z Stack
            // MARK: NAVLINK TEST -
//        } // Nav
        
        .onAppear() {
            //MARK: CoreData -
            genreStore.loadAllGenres()

//            let moviesStore = MoviesStore()
//            moviesStore.deleteAllMovie()
//
//
            
            
        }
        
    } // body
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
