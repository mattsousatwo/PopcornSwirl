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
    
    var ratings: [Rating] {
        switch type {
        case .popularMovie:
            return movieStore.ratingsForBar(type: .popularMovie)
        case .upcommingMovie:
            return movieStore.ratingsForBar(type: .upcommingMovie)
        case .recommendedMovie:
            return movieStore.ratingsForBar(type: .recommendedMovie, id: id)
        case .actors:
            return movieStore.ratingsForBar(type: .actors, id: id)
        case .actorMovie:
            return movieStore.ratingsForBar(type: .actorMovie, id: id)
        case .actorTV:
            return movieStore.ratingsForBar(type: .actorTV, id: id)
        }
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
                        
                        if let ratings = ratings {
                            if let actorMovieRating = ratings.first(where: { $0.uuid == Double(actorMovies[i].id) }) {
                                
                                if let moviePosterPath = actorMovies[i].poster_path,
                                   let movieTitle = actorMovies[i].title {
                                    
                                    LabeledScrollNavLink(imagePath: moviePosterPath,
                                                         actorID: actorMovies[i].id,
                                                         title: movieTitle,
                                                         subtitle: actorMovies[i].character,
                                                         rating: actorMovieRating)
                                }
                                
                                
                                
                            }
                        }
                   
                    } // if i
              
                } // For
                
            case .actorTV:
                
                if actorTVSeries.count != 0 {
                    ForEach(0..<actorTVSeries.count, id: \.self) { i in
                        if i <= 9 {
                            
                            if let ratings = ratings {
                                if let actorTVSeriesRating = ratings.first(where: { $0.uuid == Double(actorTVSeries[i].id) }) {


                                    ScrollNavLink(movieID: actorTVSeries[i].id,
                                                  title: actorTVSeries[i].title ?? "",
                                                  genreIDs: actorTVSeries[i].genre_ids,
                                                  overview: actorTVSeries[i].overview,
                                                  posterPath: actorTVSeries[i].poster_path ?? "",
                                                  voteAverage: actorTVSeries[i].vote_average,
                                                  releaseDate: actorTVSeries[i].release_date ?? "",
                                                  rating: actorTVSeriesRating)
                                }
                            }


                            
                        }
                    }

                    .animation(.default)
                }
                
                
                
            // MARK: ACTORS -
            case .actors:
                
                if actorImages.count != 0 {
                    ForEach(0..<actorImages.count, id: \.self) { i in
                        if i <= 9 {

                            
                            if let ratings = ratings {
                                if let actorRating = ratings.first(where: { $0.uuid == Double(cast[i].id) }) {
                                    if let imagePath = actorImages[ cast[i].id ] {
                                        
                                        LabeledScrollNavLink(imagePath: imagePath,
                                                             actorID: cast[i].id,
                                                             title: cast[i].name,
                                                             subtitle: cast[i].character,
                                                             rating: actorRating)
                                    }
                                }
                            }

                            
                        } // i <= 9
                    } // for

                    .animation(.default)
                } // if
            
            
            
            // MARK: POPULAR MOVIE -
            case .popularMovie:
                
                ForEach(0..<popularMovies.count, id: \.self) { i in
                    if popularMovies.count != 0 {
                        
                        
                        if let ratings = ratings {
                            
                            if let movieRating = ratings.first(where: { $0.uuid == Double(popularMovies[i].id) } ) {
                                
                                
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
                }
                .animation(.default)
                
            // MARK: UPCOMMING MOVIE -
            case .upcommingMovie:
                ForEach(0..<upcomingMovies.count, id: \.self) { i in
                    if upcomingMovies.count != 0 {
                        
                        if let ratings = ratings {
                            if let upcomingMovieRating = ratings.first(where: { $0.uuid == Double(upcomingMovies[i].id) } ) {
                                
                                ScrollNavLink(movieID: upcomingMovies[i].id,
                                              title: upcomingMovies[i].title,
                                              genreIDs: upcomingMovies[i].genre_ids,
                                              overview: upcomingMovies[i].overview,
                                              posterPath: upcomingMovies[i].poster_path ?? "",
                                              voteAverage: upcomingMovies[i].vote_average,
                                              releaseDate: upcomingMovies[i].release_date,
                                              rating: upcomingMovieRating)
                                
                            }
                        }
                        
                    }
                }
                
                .animation(.default)
                
            // MARK: RECOMMENDED MOVIE -
            case .recommendedMovie:
                ForEach(0..<recommendedMovies.count, id: \.self) { i in
                    if recommendedMovies.count != 0 {
                        
                        if let ratings = ratings {
                            if let reccomendedMovieRating = ratings.first(where: { $0.uuid == Double(recommendedMovies[i].id) }) {
                                if let releaseDate = recommendedMovies[i].release_date {
                                    ScrollNavLink(movieID: recommendedMovies[i].id,
                                                  title: recommendedMovies[i].title,
                                                  genreIDs: recommendedMovies[i].genre_ids,
                                                  overview: recommendedMovies[i].overview,
                                                  posterPath: recommendedMovies[i].poster_path ?? "",
                                                  voteAverage: recommendedMovies[i].vote_average,
                                                  releaseDate: releaseDate,
                                                  rating: reccomendedMovieRating)
                                }
                            }
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

// Navigation Link with 2 labels
struct LabeledScrollNavLink: View {
    
    var imagePath: String
    var actorID: Int
    var title: String
    var subtitle: String
    var rating: Rating?
    
    var body: some View {
        
        
        if let rating = rating {
            
            NavigationLink(destination: ActorDetail(image: MovieStoreKey.imageURL.rawValue + imagePath,
                                                    actorID: actorID,
                                                    name: title,
                                                    isFavorite: rating.isFavorite)) {
                LabeledMovieCard(url: URL(string: MovieStoreKey.imageURL.rawValue + imagePath),
                                 title: title, subtitle: subtitle, rating: rating)
            }
        }
        
    }
}
