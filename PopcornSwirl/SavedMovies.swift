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
}

// Used to push movie selection on screen.
/// When Movie Type changes a new Saved MovieRow will load
class SavedMovieType: ObservableObject {
    @Published var type: SavedMoviesViewType = .favorite
}

struct SavedMovies: View {
    
    @ObservedObject var movieStore = MoviesStore()
    @ObservedObject var savedType = SavedMovieType()
    @State private var viewType: SavedMoviesViewType = .favorite
    private var viewOptions: [SavedMoviesViewType] = [.favorite, .watched]
    
    var body: some View {
        NavigationView {
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
                    }
                    .padding()
                    // Saved Movies Body
                    switch savedType.type {
                    case .favorite:
                        SavedMovieBody(type: .favorite)
                    case .watched:
                        SavedMovieBody(type: .watched)
                    }
                }
            } // Z
            .navigationBarTitle("\(viewType.rawValue) Movies", displayMode: .inline)
        }
    } // Body
    
} // SavedMovies()


struct SavedMovieBody: View {
    
    var displayLimit: Int = 9 // movie count is doubled - ( 9 = 20 movies shown ) - ( 9+1 = 10, 10 * 2 = 20  )
    
    var type: SavedMoviesViewType
    var movieStore = MoviesStore()
    
    // Get All Favorited Movies
    private var favoriteMovies: [[Movie]]? {
        return movieStore.fetchFavorites()
    }
    
    // Get All Watched Movies
    private var watchedMovies: [[Movie]]? {
        return movieStore.fetchWatched()
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .center) {
                    switch type {
                    case .favorite:
                        if let favorites = favoriteMovies {
                            MovieRow(movies: favorites)
                                .animation(.default)
                        } else {
                            HStack {
                                Spacer()
                                Text("No Favorite Movies")
                                Spacer()
                            }
                            Spacer()
                        }
                    case .watched:
                        if let watched = watchedMovies {
                            MovieRow(movies: watched)
                                .animation(.default)
                        } else {
                            HStack {
                                Spacer()
                                Text("No Watched Movies")
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


struct MovieRow: View {
    var movies: [[Movie]]
    var displayLimit: Int = 9
    var body: some View {
        ForEach(0..<movies.count, id: \.self) { i in
            if i <= displayLimit {
                HStack {
                    ForEach(movies[i], id: \.self) { movie in
                        NavigationLink(destination: MovieDetail(movieID: Int(movie.uuid),
                                                                movieTitle: movie.title ?? "",
                                                                movieOverview: movie.overview ?? "",
                                                                posterPath: movie.imagePath ?? "",
                                                                rating: movie.rating,
                                                                releaseDate: movie.releaseDate ?? ""),
                                       label: {
                                        ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + (movie.imagePath ?? "")), movie: movie)
                                       })
                    } // ForEach
                    .padding(.horizontal)
                    Spacer()
                } // Hstack
                .frame(width: UIScreen.main.bounds.size.width,
                       height: 200,
                       alignment: .center)
                .padding()
            } // if
        } // ForEach
        .padding()
    }
}
