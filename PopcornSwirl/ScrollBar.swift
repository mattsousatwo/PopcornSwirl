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
    case upcomingMovie = "Upcomming"
    case recommendedMovie = "Recommended" // Need to access movie ID
    case actors = "Actors" // Need to access movie ID
    case actorMovie = "Movies"
    case actorTV = "TV"
}


struct ScrollBar: View, Equatable {
    
    @ObservedObject var movieStore = MovieStore()
    @ObservedObject var actorsStore = ActorsStore()
    @ObservedObject var seriesStore = SeriesStore()
    
    var type: ScrollBarType
    var id: Int = 0
    
    // Coredata properties
    var movieCast: [MovieCast]?
    var recommendedMovie: [RecommendedMovie]?
    
    // TMDB
    var movies: [Movie]? {
        switch type {
        case .popularMovie:
            return movieStore.movieForBar(.popularMovie)
        case .upcomingMovie:
            return movieStore.movieForBar(.upcomingMovie)
        case .recommendedMovie:
            return movieStore.movieForBar(.recommendedMovie, id: id)
        case .actors:
            return nil
        case .actorMovie:
            return movieStore.movieForBar(.actorMovie, id: id)
        case .actorTV:
            return movieStore.movieForBar(.actorTV, id: id)
        }
    }
    
    var actors: [Actor]? {
        switch type {
        case .actors:
            let actorIDs = movieStore.extractIDsFor(.actors, id: id)
            let y = actorsStore.fetchAllActorsWith(ids: actorIDs)
            print("FOUND ACTORS: \(y.count)")
            
            return y
        default:
            return nil 
        }
    }
    
    var series: [Series]? {
        switch type {
        case .actorTV:
            let seriesIDs = movieStore.extractIDsFor(.actorTV, id: id)
            return seriesStore.fetchArrayOfSeries(withIDs: seriesIDs)
        default:
            return nil
        }
        
    }
    
    static func == (lhs: ScrollBar, rhs: ScrollBar) -> Bool {
        return lhs.type == rhs.type
    }
    
    
    
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
                    if let movies = movies {
                        Bar(type: type, id: id, movies: movies) // add actors
                    }
                    if let actors = actors {
                        Bar(type: type, id: id, actors: actors, movieCast: movieCast)
                    }
                    if let series = series {
                        Bar(type: type, id: id, series: series)
                    }
                    
                } .padding() // HStack
  
            } // ScrollView - Content

        } // VStack - end
        
        
        
    }
    
}


struct Bar: View {
    
    var type: ScrollBarType
    
    var id: Int // used to fetch recomended movies
    
    var movies: [Movie]?
    
    // add actors
    var actors: [Actor]?
    
    var movieCast: [MovieCast]?
    var recMovie: [RecommendedMovie]?
    
    /// Coredata Series
    var series: [Series]?
    
    @ObservedObject var movieCD = MoviesStore()
    
    private var popularMovies : [PopMovie] {
        return movieStore.extractPopularMovies()
    }

    private var recommendedMovies: [RecommendedMovie] {
        let movies = movieStore.extractRecomendedMovies(id: id)
        print("ReccomendedMovies.count: \(movies.count)")
        return movies
    }

    private var upcomingMovies: [UpcomingMovie] {
        return movieStore.extractUpcomingMovies()
    }

    private var cast: [MovieCast] {
        let c = movieStore.extractMovieCast(id: id)
        print("Cast: \(c) ")
        return c
    }

    private var actorImages: [Int : String ] {
        return movieStore.extractActorImageProfiles(id: id)
    }

    // TV
    private var actorMovies: [ActorCreditsCast] {
        var credits: [ActorCreditsCast] = []
        let actor = actorStore.fetchActorWith(id: id)
        if let encodedCredits = actor.credits {
            if let decodedCredits = actorStore.decodeActorCredits(encodedCredits) {
                print("actorMovie - Coredata")
                for movie in decodedCredits {
                    if movie.media_type == "movie" {
                        credits.append(movie)
                    }
                }
            }
        }
        if credits.isEmpty == true {
            print("actorMovie - TMDB")
            return movieStore.extractCreditsFor(actorID: id, type: .movie)
        }
        return credits
    }
    
    
    private var actorTVSeries: [ActorCreditsCast] {
        var credits: [ActorCreditsCast] = []
        let actor = actorStore.fetchActorWith(id: id)
        if let encodedCredits = actor.credits {
            if let decodedCredits = actorStore.decodeActorCredits(encodedCredits) {
                print("actorTV - Coredata")
                for movie in decodedCredits {
                    if movie.media_type == "tv" {
                        credits.append(movie)
                    }
                }
            }
        }
        if credits.isEmpty == true {
            print("actorTV - TMDB")
            return movieStore.extractCreditsFor(actorID: id, type: .tv)
        }
        return credits
    }

    @ObservedObject var movieStore = MovieStore()
    @ObservedObject var actorStore = ActorsStore()
    
    var body: some View {

        
            switch type {
            case .actorMovie:
                ForEach(0..<actorMovies.count, id: \.self) { i in
                    if i <= 9 {
                        if let movies = movies {
                            if let id = actorMovies[i].id {
                                if let actorMovie = movies.first(where: { $0.uuid == Double(id) }) {
                                    
                                    if let moviePosterPath = actorMovies[i].poster_path,
                                       let movieTitle = actorMovies[i].title {
                                        
                                        LabeledScrollNavLink(imagePath: moviePosterPath,
                                                             actorID: id,
                                                             title: movieTitle,
                                                             subtitle: actorMovies[i].character,
                                                             movie: actorMovie)
                                    }
                                }
                            }
                        }
                    } // if i
              
                } // For
            
            case .actorTV:
                
                if actorTVSeries.count != 0 {
                    ForEach(0..<actorTVSeries.count, id: \.self) { i in
                        if i <= 9 {
                            if let series = series {
                                if let id = actorTVSeries[i].id {
                                    if let tVSeries = series.first(where: { $0.uuid == Double(id) }) {
                                        
                                        
                                        
                                        
                                        ScrollNavLink(movieID: id,
                                                      title: actorTVSeries[i].title ?? "",
                                                      genreIDs: actorTVSeries[i].genre_ids,
                                                      overview: actorTVSeries[i].overview,
                                                      posterPath: actorTVSeries[i].poster_path ?? "",
                                                      voteAverage: actorTVSeries[i].vote_average,
                                                      releaseDate: actorTVSeries[i].release_date ?? "",
                                                      series: tVSeries)
                                                      
                                    }
                                }
                            }
                        }
                    }
                    
                    .animation(.default)
                }
                
            // MARK: ACTORS
            case .actors:
                if actorImages.count != 0 {
                    ForEach(0..<actorImages.count, id: \.self) { i in
                        if i <= 9 {
                            
                            if let actor = actors?.first(where: { $0.id == Double(cast[i].id) }) {
                                // Actors from Coredata
                                if let movieCast = movieCast { 
                                    if let imagePath = actorImages[ movieCast[i].id ] {
                                        LabeledScrollNavLink(imagePath: imagePath,
                                                             actorID: movieCast[i].id,
                                                             title: movieCast[i].name,
                                                             subtitle: movieCast[i].character,
                                                             movie: nil,
                                                             actor: actor)
                                        
                                    }
                                }
                                else {
                                    // Actors from TMDB
                                    if let imagePath = actorImages[ cast[i].id ] {
                                        LabeledScrollNavLink(imagePath: imagePath,
                                                             actorID: cast[i].id,
                                                             title: cast[i].name,
                                                             subtitle: cast[i].character,
                                                             movie: nil,
                                                             actor: actor)
                                    }
                                }
                            }
                            
                        } // i <= 9
                    } // for
                    
                    .animation(.default)
                } // if
            
            // MARK: POPULAR MOVIE -
            case .popularMovie:
                
                if let movies = movies {
                    ForEach(0..<movies.count, id: \.self) { i in
                        
                        // Coredata
                        let movie = movies[i] 
                        
                        if let genres = movie.genres {
                            if let decodedGenres = movieCD.decodeGenres(genres) {
                                
                                ScrollNavLink(movieID: Int(movie.uuid),
                                              title: movie.title ?? "",
                                              genreIDs: decodedGenres,
                                              overview: movie.overview ?? "",
                                              posterPath: movie.imagePath ?? "",
                                              voteAverage: movie.voteAverage,
                                              releaseDate: movie.releaseDate ?? "",
                                              movie: movie)
                                    .animation(.default)
                            }
                        }
                    }
                    
                } else if movies?.count != popularMovies.count {
                    ForEach(0..<popularMovies.count, id: \.self) { i in
                        if popularMovies.count != 0 {
                            if let movies = movies {
                                if let movie = movies.first(where: { $0.uuid == Double(popularMovies[i].id) } ) {
                                    ScrollNavLink(movieID: popularMovies[i].id,
                                                  title: popularMovies[i].title,
                                                  genreIDs: popularMovies[i].genre_ids,
                                                  overview: popularMovies[i].overview,
                                                  posterPath: popularMovies[i].poster_path,
                                                  voteAverage: popularMovies[i].vote_average,
                                                  releaseDate: popularMovies[i].release_date,
                                                  movie: movie)
                                        .animation(.default)
                                }
                            }
                        }
                    }
                }
            // MARK: UPCOMMING MOVIE -
            case .upcomingMovie:

                // CoreData
                if let movies = movies {
                    if upcomingMovies.count != 0 {
                        ForEach(0..<movies.count, id: \.self) { i in
                            // Coredata
                            let movie = movies[i]
                            // TMDB
                            let upcomingMovie = upcomingMovies[i]
                            
                            if let genres = movie.genres {
                                if let genresArray = movieCD.decodeGenres(genres) {
                                    ScrollNavLink(movieID: Int(movie.uuid),
                                                  title: movie.title ?? upcomingMovie.title,
                                                  genreIDs: genresArray,
                                                  overview: movie.overview ?? upcomingMovie.overview,
                                                  posterPath: movie.imagePath ?? upcomingMovie.poster_path ?? "",
                                                  voteAverage: movie.rating,
                                                  releaseDate: movie.releaseDate ?? upcomingMovie.release_date,
                                                  movie: movie)
                                        .animation(.default)
                                }
                            }
                        }
                    }
                    
                    
                    // MARK: -
                } else if movies?.count != upcomingMovies.count {
                    ForEach(0..<upcomingMovies.count, id: \.self) { i in
                        if upcomingMovies.count != 0 {
                            if let movies = movies {
                                if let upcomingMovie = movies.first(where: { $0.uuid == Double(upcomingMovies[i].id) } ) {

                                    ScrollNavLink(movieID: upcomingMovies[i].id,
                                                  title: upcomingMovies[i].title,
                                                  genreIDs: upcomingMovies[i].genre_ids,
                                                  overview: upcomingMovies[i].overview,
                                                  posterPath: upcomingMovies[i].poster_path ?? "",
                                                  voteAverage: upcomingMovies[i].vote_average,
                                                  releaseDate: upcomingMovies[i].release_date,
                                                  movie: upcomingMovie)

                                }
                            }
                        }
                    }
                    .animation(.default)
                }
                
                
            // MARK: RECOMMENDED MOVIE -
            case .recommendedMovie:
                

                if let movies = movies {
                    if recommendedMovies.count != 0 {
                        ForEach(0..<movies.count, id: \.self) { i in
                            // TMDB
                            let recMovie = recommendedMovies[i]
                            // Coredata
                            let movie = movies[i]

                            if recMovie.id == Int(movie.uuid) {
                                if let genres = movie.genres {
                                    if let decodedGenres = movieCD.decodeGenres(genres) {
                                        ScrollNavLink(movieID: Int(movie.uuid),
                                                      title: movie.title ?? recMovie.title,
                                                      genreIDs: decodedGenres,
                                                      overview: movie.overview ?? recMovie.overview,
                                                      posterPath: movie.imagePath ?? recMovie.poster_path ?? "",
                                                      voteAverage: movie.rating,
                                                      releaseDate: movie.releaseDate ?? recMovie.release_date ?? "",
                                                      movie: movie)
                                            .animation(.default)

                                    }
                                }
                            }
                        }
                    }
                } else if recommendedMovies.count != movies?.count {
                    ForEach(0..<recommendedMovies.count, id: \.self) { i in
                        if recommendedMovies.count != 0  {
                            if let movies = movies {
                                if let recommendedMovieID = recommendedMovies[i].id {
                                    if let movie = movies.first(where: { $0.uuid == Double(recommendedMovieID) }) {
                                        ScrollNavLink(movieID: recommendedMovieID,
                                                      title: recommendedMovies[i].title,
                                                      genreIDs: recommendedMovies[i].genre_ids,
                                                      overview: recommendedMovies[i].overview,
                                                      posterPath: recommendedMovies[i].poster_path ?? "",
                                                      voteAverage: recommendedMovies[i].vote_average,
                                                      releaseDate: recommendedMovies[i].release_date ?? "",
                                                      movie: movie)
                                            .animation(.default)
                                    }
                                }
                            }
                        }
                    }
                }

            

                
                
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



// Navigation Link for Scroll Bar
struct ScrollNavLink: View {
    
    var movieID: Int
    var title: String
    var genreIDs: [Int]
    var overview: String
    var posterPath: String
    var voteAverage: Double
    var releaseDate: String
    var movie: Movie?
    var series: Series?
    
    var body: some View {
        if let movie = movie {
            NavigationLink(destination: MovieDetail(movieID: movieID,
                                                    movieTitle: title,
                                                    genreIDs: genreIDs,
                                                    movieOverview: overview,
                                                    posterPath: posterPath,
                                                    rating: voteAverage,
                                                    releaseDate: releaseDate).equatable() ) {
                
                ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + posterPath),
                          movie: movie)
            }
        } else if let series = series {
            NavigationLink(destination: MovieDetail(movieID: movieID,
                                                    movieTitle: title,
                                                    genreIDs: genreIDs,
                                                    movieOverview: overview,
                                                    posterPath: posterPath,
                                                    rating: voteAverage,
                                                    releaseDate: releaseDate).equatable() ) {
                
                ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + posterPath),
                          series: series)
            }
        }
        
        
        
        
    }
}

/// Navigation Link with 2 labels
struct LabeledScrollNavLink: View {
    
    var imagePath: String
    var actorID: Int
    var title: String
    var subtitle: String
    var movie: Movie?
    var actor: Actor?
    
    var body: some View {
        
        if let actor = actor {
            NavigationLink(destination: ActorDetail(image: MovieStoreKey.imageURL.rawValue + imagePath,
                                                    actorID: actorID,
                                                    name: title,
                                                    actor: actor,
                                                    isFavorite: actor.isFavorite)) {
                
                LabeledImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + imagePath),
                                 title: title, subtitle: subtitle, actor: actor)
            }
        }
        
        if let movie = movie {
            
            NavigationLink(destination: MovieDetail(movieID: Int(movie.uuid),
                                                    movieTitle: movie.title ?? "",
                                                    movieOverview: movie.overview ?? "",
                                                    posterPath: movie.imagePath ?? "",
                                                    rating: movie.rating,
                                                    releaseDate: movie.releaseDate ?? "")) {
                LabeledImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + imagePath),
                                 title: title, subtitle: subtitle, movie: movie)
            }

            
//            
//            NavigationLink(destination: ActorDetail(image: MovieStoreKey.imageURL.rawValue + imagePath,
//                                                    actorID: actorID,
//                                                    name: title,
//                                                    isFavorite: movie.isFavorite)) {
//                LabeledImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + imagePath),
//                                 title: title, subtitle: subtitle, movie: movie)
//            }
        }
        
            

    }
}
