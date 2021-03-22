//
//  SavedMovies.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/24/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

enum SavedMoviesViewType: String, Hashable {
    case favorite = "Favorite"
    case watched = "Watched"
    case actors = "Actors"
}

// Used to push movie selection on screen.
/// When Movie Type changes a new Saved MovieRow will load
class SavedMovieType: ObservableObject {
    @Published var type: SavedMoviesViewType = .favorite
}

struct SavedMovies: View {
    
    @ObservedObject var movieStore = MoviesStore()
    @ObservedObject var savedType = SavedMovieType()
    private var viewOptions: [SavedMoviesViewType] = [.favorite, .watched, .actors]
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    var body: some View {
            ZStack(alignment: .center) {
                // Background
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(edges: .vertical)
                // View Control Picker
                VStack {
                    HStack {
                        Picker(selection: $savedType.type,
                               label: Text("View Type"),
                               content: {
                                ForEach(viewOptions, id: \.self) {
                                    Text($0.rawValue)
                                }
                               }).pickerStyle(SegmentedPickerStyle())
                            .shadow(radius: 2)
                        }
                    .padding()
                    // Saved Movies Body
                    switch savedType.type {
                    case .favorite:
                        SavedMovieBody(type: .favorite)
                    case .watched:
                        SavedMovieBody(type: .watched)
                    case .actors:
                        SavedMovieBody(type: .actors)
                    }
                }
            } // Z
            .navigationBarTitle("\(savedType.type.rawValue) Movies", displayMode: .inline)
    } // Body
    
} // SavedMovies()


struct SavedMovieBody: View {

    var displayLimit: Int = 9 // movie count is doubled - ( 9 = 20 movies shown ) - ( 9+1 = 10, 10 * 2 = 20  )
    
    var type: SavedMoviesViewType
    var movieStore = MoviesStore()
    var actorsStore = ActorsStore()
    
    // Get All Favorited Movies
    private var favoriteMovies: [[Movie]]? {
        return movieStore.fetchFavorites()
    }
    
    // Get All Watched Movies
    private var watchedMovies: [[Movie]]? {
        return movieStore.fetchWatched()
    }
    
    /// All favorite actors 
    private var actors: [[Actor]]? {
        return actorsStore.fetchFavoritedActors()
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .center) {
                    switch type {
                    case .favorite:
                        if let favorites = favoriteMovies {
                            MovieRow(movies: favorites).equatable()
                                .animation(.default)
                        } else {
                            HStack {
                                Spacer()
                                Text("0 Favorite Movies Found")
                                Spacer()
                            }
                            Spacer()
                        }
                    case .watched:
                        if let watched = watchedMovies {
                            MovieRow(movies: watched).equatable()
                                .animation(.default)
                        } else {
                            HStack {
                                Spacer()
                                Text("0 Watched Movies Found")
                                Spacer()
                            }
                            Spacer()
                        }
                        
                    case .actors:
                        
                        if let actors = actors {
                            MovieRow(actors: actors).equatable()
                                .frame(width: geo.size.width)
                                
                                .animation(.default)
                        } else {
                            HStack {
                                Spacer()
                                Text("0 Favorited Actors Found")
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        
                    }
                } // VStack
            }
            .animation(.default)
            
        }
    }
    
}

// Equatable
struct MovieRow: View, Equatable {
    
    static func == (lhs: MovieRow, rhs: MovieRow) -> Bool {
        lhs.movies == rhs.movies || lhs.actors == rhs.actors
    }
    
    
    var movies: [[Movie]]?
    var actors: [[Actor]]?
    var displayLimit: Int = 9
    
    
    private let columnSize = [ GridItem(.adaptive(minimum: 150)) ]
    
    
    var body: some View {
        
        // MARK: If Movie
        if let movieArray = movies {
            LazyVGrid(columns: columnSize, alignment: .center, spacing: 20) {
                ForEach(0..<movieArray.count, id: \.self) { i in
                    if i <= displayLimit {
                        ForEach(movieArray[i], id: \.self) { movie in
                            NavigationLink(destination: MovieDetail(movieID: Int(movie.uuid),
                                                                    movieTitle: movie.title ?? "",
                                                                    movieOverview: movie.overview ?? "",
                                                                    posterPath: movie.imagePath ?? "",
                                                                    rating: movie.rating,
                                                                    releaseDate: movie.releaseDate ?? "").equatable() ,
                                           label: {
                                            ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + (movie.imagePath ?? "")), movie: movie)
                                           })
                        }
                        
                        
                    }
                    
                }
                
            } // ForEach
            .padding()
            
            
            
            
            
            
        } else if let actors = actors {
            
            LazyVGrid(columns: columnSize, alignment: .center, spacing: 20) {
                // MARK: If Actor
                ForEach(0..<actors.count, id: \.self) { i in
                    if i <= displayLimit {
                        ForEach(actors[i], id: \.self) { actor in
                            let imagePath = MovieStoreKey.imageURL.rawValue + (actor.imagePath ?? "")
                            NavigationLink(destination: ActorDetail(image: imagePath,
                                                                    actorID: Int(actor.id),
                                                                    name: actor.name ?? "",
                                                                    actor: actor,
                                                                    isFavorite: actor.isFavorite) ,
                                           label: {
                                            ImageCard(url: URL(string: imagePath),
                                                      actor: actor)
                                           })
                        } // ForEach
    
                    } // if
                } // ForEach
            }
            .padding()
            
            
            
            
        }
        


    }
    
}
