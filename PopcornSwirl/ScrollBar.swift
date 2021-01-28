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
    case actorMovie = "Movies"
    case actorTV = "TV"
}


struct ScrollBar: View {
    
    @ObservedObject var movieStore = MovieStore()
    @ObservedObject var ratingsStore = MovieRatingStore()
    
    
    var type: ScrollBarType
    
    var id: Int = 0
    
    var ratings: [Rating]? {
        print("PopularMovieIDs: Start")
        switch type {
        case .popularMovie:
            let popularMovieIDs = movieStore.extractIDsFor(.popularMovie)
            print("PopularMovieIDs: \(popularMovieIDs)")
            return ratingsStore.fetchAllRatingsUsingIDs(in: popularMovieIDs)
        default:
            break
        }
        return nil
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
                    
                    bar(type: type, id: id, ratings: ratings)

                } .padding() // HStack
  
            } // ScrollView - Content

        } // VStack - end
        
        
        
    }
    
}


struct bar: View {
    
    
    var type: ScrollBarType
    
    var id: Int // used to fetch recomended movies
    
    var ratings: [Rating]?
    
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

    // TV
    private var actorMovies: [ActorCreditsCast] {
        return movieStore.extractCreditsFor(actorID: id, type: .movie)
    }
    private var actorTVSeries: [ActorCreditsCast] {
        return movieStore.extractCreditsFor(actorID: id, type: .tv)
    }

    @ObservedObject var movieStore = MovieStore()

    var body: some View {

        
            switch type {
            case .actorMovie:
                ForEach(0..<actorMovies.count, id: \.self) { i in
                    if i <= 9 {
                        if let moviePosterPath = actorMovies[i].poster_path,
                           let movieTitle = actorMovies[i].title {
 
                            
                        
                            NavigationLink(destination: MovieDetail(movieID: actorMovies[i].id,
                                                                    movieTitle: movieTitle,
                                                                    genreIDs: actorMovies[i].genre_ids,
                                                                    movieOverview: actorMovies[i].overview,
                                                                    posterPath: moviePosterPath,
                                                                    rating: actorMovies[i].vote_average,
                                                                    releaseDate: actorMovies[i].release_date ?? ""),
                                           label: {
                                            LabeledMovieCard(url: URL(string: MovieStoreKey.imageURL.rawValue + moviePosterPath),
                                                             title: actorMovies[i].character)
                                            
                                           })
                            
                            
                            
                            
                        } // if let
                    } // if i
                } // For
            
//                .onAppear {
//                    let actorMovieIDs = actorMovies.map({ $0.id })
//                    ratings = ratingStore.fetchAllRatingsUsingIDs(in: actorMovieIDs)
//                }
                
            case .actorTV:
                
                if actorTVSeries.count != 0 {
                    ForEach(0..<actorTVSeries.count, id: \.self) { i in
                        if i <= 9 {
                            
                            
                            NavigationLink(destination: MovieDetail(movieID: actorTVSeries[i].id,
                                                                    movieTitle: actorTVSeries[i].title ?? "No Title",
                                                                    genreIDs: actorTVSeries[i].genre_ids,
                                                                    movieOverview: actorTVSeries[i].overview,
                                                                    posterPath: actorTVSeries[i].poster_path ?? "",
                                                                    rating: actorTVSeries[i].vote_average,
                                                                    releaseDate: actorTVSeries[i].release_date ?? ""),
                                           label: {
                                            
                                            MovieCard(url: URL(string: MovieStoreKey.imageURL.rawValue + (actorTVSeries[i].poster_path ?? "") ))
                                            //                                        LabeledMovieCard(url: URL(string: movieStore.imageURL + (actorTVSeries[i].poster_path ?? "")),
                                            //                                                         subtitle: actorTVSeries[i].character)
                                           })
                            
                        }
                    }
//                    .onAppear {
//                        let actorTVSeriesIDs = actorTVSeries.map{( $0.id )}
//                        ratings = ratingStore.fetchAllRatingsUsingIDs(in: actorTVSeriesIDs)
//                    }
                    .animation(.default)
                }
                
                
                
            // MARK: ACTORS -
            case .actors:
                
                if actorImages.count != 0 {
                    ForEach(0..<actorImages.count, id: \.self) { i in
                        if i <= 9 {
                            if let imagePath = actorImages[ cast[i].id ] {
                                
                                NavigationLink(
                                    destination: ActorDetail(image: MovieStoreKey.imageURL.rawValue + imagePath,
                                                             actorID: cast[i].id,
                                                             name: cast[i].name,
                                                             isFavorite: false),   // Get Coredata Rating
                                    label: {
                                        
                                        LabeledMovieCard(url: URL(string: MovieStoreKey.imageURL.rawValue + imagePath),
                                                         title: cast[i].name,
                                                         subtitle: cast[i].character)
                                    })
                                
                            } // imagePath
                        } // i <= 9
                    } // for
                    
//                    .onAppear(perform: {
//                        let actorIDs = actorImages.map({ $0.key })
//                        ratings = ratingStore.fetchAllRatingsUsingIDs(in: actorIDs)
//
//                    })
                    .animation(.default)
                } // if
            
            
            
            // MARK: POPULAR MOVIE -
            case .popularMovie:
                
                ForEach(0..<popularMovies.count, id: \.self) { i in
                    if popularMovies.count != 0 {
                        if let movieRating = ratings?.first(where: { $0.id == popularMovies[i].id } ) { 
                            
                            
                            ScrollNavLink(movieID: popularMovies[i].id,
                                          title: popularMovies[i].title,
                                          genreIDs: popularMovies[i].genre_ids,
                                          overview: popularMovies[i].overview,
                                          posterPath: popularMovies[i].poster_path,
                                          voteAverage: popularMovies[i].vote_average,
                                          releaseDate: popularMovies[i].release_date,
                                          rating: movieRating)
                        }

                        
                        
                        
                        
                    }
                }
                
//                .onAppear(perform: {
//                    let popularMovieIDs = popularMovies.map({ $0.id })
//                    ratings = ratingStore.fetchAllRatingsUsingIDs(in: popularMovieIDs)
//                })
//
                .animation(.default)
                
            // MARK: UPCOMMING MOVIE -
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
                            MovieCard(url: URL(string: MovieStoreKey.imageURL.rawValue + (upcomingMovies[i].poster_path ?? "") ))
                        }

                    }
                }
                
//                .onAppear(perform: {
//                    let upcommingMovieIDs = upcomingMovies.map({ $0.id })
//                    ratings = ratingStore.fetchAllRatingsUsingIDs(in: upcommingMovieIDs)
//                })
                .animation(.default)
                
            // MARK: RECOMMENDED MOVIE -
            case .recommendedMovie:
                ForEach(0..<recommendedMovies.count, id: \.self) { i in
                    if recommendedMovies.count != 0 {
                        if let releaseDate = recommendedMovies[i].release_date {
                            
                            
                            
                           
                            
                            NavigationLink(destination: MovieDetail(movieID: recommendedMovies[i].id,
                                                                    movieTitle: recommendedMovies[i].title,
                                                                    genreIDs: recommendedMovies[i].genre_ids,
                                                                    movieOverview: recommendedMovies[i].overview,
                                                                    posterPath: recommendedMovies[i].poster_path ?? "",
                                                                    rating: recommendedMovies[i].vote_average,
                                                                    releaseDate: releaseDate)  ) {
                                // Label
                                MovieCard(url: URL(string: MovieStoreKey.imageURL.rawValue + (recommendedMovies[i].poster_path ?? "") ))
                                //                        RemotePoster(url: movieStore.imageURL + (recommendedMovies[i].poster_path ?? "") )
                            }
                        }
                    }
                }
                
//                .onAppear(perform: {
//                    let recommendedMovieIDs = recommendedMovies.map({ $0.id })
//                    ratings = ratingStore.fetchAllRatingsUsingIDs(in: recommendedMovieIDs)
//                })
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



struct ActorScrollBar: View {
    var body: some View {
        Text("Hello world")
    }
}

enum MovieBarType: String  {
    case popularMovie = "Popular"
    case upcommingMovie = "Upcomming"
    case recommendedMovie = "Recommended"
}

struct MovieScrollBar: View {
    
    @ObservedObject var movieStore = MovieStore()
    
    var type: MovieBarType
    
    var id: Int
    
    @State var ratings: [Rating]?
    var ratingStore = MovieRatingStore()
    
    var popularMovies : [PopMovie] {
        return movieStore.extractPopularMovies()
    }

    private var recommendedMovies: [RecommendedMovie] {
        return movieStore.extractRecomendedMovies(id: id)
    }

    private var upcomingMovies: [UpcomingMovie] {
        return movieStore.extractUpcomingMovies()
    }
    
    
    var body: some View {
    
        switch type {
        case .popularMovie:
            
            ForEach(0..<popularMovies.count, id: \.self) { i in
                if popularMovies.count != 0 {
//                    if let ratings = ratings {
//                        let aID = popularMovies[i].id
//                        if let movieRating = ratings.first(where: { $0.id == aID }) {
//
//                        }
//                    }
                    
                    ScrollNavLink(movieID: popularMovies[i].id,
                                  title: popularMovies[i].title,
                                  genreIDs: popularMovies[i].genre_ids,
                                  overview: popularMovies[i].overview,
                                  posterPath: popularMovies[i].poster_path,
                                  voteAverage: popularMovies[i].vote_average,
                                  releaseDate: popularMovies[i].release_date,
                                  rating: nil)
                }
            }
            .animation(.default)
            .onAppear(perform: {
                let popularMovieIDs = popularMovies.map({ $0.id })
                ratings = ratingStore.fetchAllRatingsUsingIDs(in: popularMovieIDs)
            })
            
            
        case .upcommingMovie:
            
            ForEach(0..<upcomingMovies.count, id: \.self) { i in
                if upcomingMovies.count != 0 {
                    ScrollNavLink(movieID: upcomingMovies[i].id,
                                  title: upcomingMovies[i].title,
                                  genreIDs: upcomingMovies[i].genre_ids,
                                  overview: upcomingMovies[i].overview,
                                  posterPath: upcomingMovies[i].poster_path ?? "",
                                  voteAverage: upcomingMovies[i].vote_average,
                                  releaseDate: upcomingMovies[i].release_date,
                                  rating: nil)
                }
            }
            .animation(.default)
            
        case .recommendedMovie:
            
            ForEach(0..<recommendedMovies.count, id: \.self) { i in
                if let releaseDate = recommendedMovies[i].release_date {
                    ScrollNavLink(movieID: recommendedMovies[i].id,
                                  title: recommendedMovies[i].title,
                                  genreIDs: recommendedMovies[i].genre_ids,
                                  overview: recommendedMovies[i].overview,
                                  posterPath: recommendedMovies[i].poster_path ?? "",
                                  voteAverage: recommendedMovies[i].vote_average,
                                  releaseDate: releaseDate,
                                  rating: nil)
                    
                    
                }
            }
            .animation(.default)
            
        }
        
        
        
        
        
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
    var rating: Rating?
    
    
    var body: some View {
        
        NavigationLink(destination: MovieDetail(movieID: movieID,
                                                movieTitle: title,
                                                genreIDs: genreIDs,
                                                movieOverview: overview,
                                                posterPath: posterPath,
                                                rating: voteAverage,
                                                releaseDate: releaseDate)) {
            
            MovieCard(url: URL(string: MovieStoreKey.imageURL.rawValue + posterPath),
                      rating: rating)
        }
        
        
    }
}
