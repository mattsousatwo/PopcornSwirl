//
//  TESTMovieDB.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 11/25/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftUI
import Combine

class MovieStore: ObservableObject {
    
    // Movie Stores
    @Published var popularMovies = [PopMovie]() // all popular movies
    @Published var movieCast = [MovieCast]() // cast for movie
    @Published var director = String() // crew for movie - director
    @Published var recommendedMovies = [RecommendedMovie]() // all recommended movies by movie ID
    @Published var movieSearchResults = [MovieSearchResults]()
    @Published var upcomingMovies = [UpcomingMovie]()
    @Published var actorImageProfiles = [Int : String]() // Stores actor images by ID
    @Published var genreDictionary = [Int: String]() // Stores genres
    @Published var actorCredits = [ActorCreditsCast]()
    
    @Published var actorDetails = [ActorDetails]()
    
    lazy var decoder = JSONDecoder() // used to decode json data
    
    lazy var imageURL = "https://image.tmdb.org/t/p/" + "original" // used as base for movie images
    lazy var apiKey = "ebccbee67fef37cc7a99378c44af7d33" // API Key
    
    // Initalizer
    init() {

    }
    
}


// MARK: Movies
extension MovieStore {
    
    // MARK: FETCH Popular Movies
    func fetchPopularMovies() {
        let popMovieRequest = "https://api.themoviedb.org/3/movie/popular?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&page=1"
        
        AF.request( popMovieRequest ).responseJSON {
            response in
            
            guard let json = response.data else { return }
            
            do {
                let decodedMovies = try self.decoder.decode(Popular.self, from: json)
                
                
                self.popularMovies = decodedMovies.results
                for i in 0..<self.popularMovies.count {
                    print("title: \(self.popularMovies[i].title), \n   overview: \(self.popularMovies[i].overview) \n   poster_path: \(self.popularMovies[i].poster_path) \n    vote avg: \(self.popularMovies[i].vote_average)" )
                    for x in 0..<self.popularMovies[i].genre_ids.count {
                        print("GenreID: \(self.popularMovies[i].genre_ids[x]) ")
                    }
                }
                
            } catch {
                print(error)
            } // do / catch

        } // request
        
    } // fetchPopularMovies
 
    // MARK: Get Reccomended Movies for movie
    func fetchRecommendedMoviesForMovie(id: Int) {
        
        let recommendedRequest = "https://api.themoviedb.org/3/movie/\(id)/recommendations?api_key=\(apiKey)&language=en-US&page=1"
        
        AF.request( recommendedRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let recomendations = try self.decoder.decode(Recommendation.self, from: json)
                
                self.recommendedMovies = recomendations.results
                for x in self.recommendedMovies {
                    print("Movie: \(x.title)")
                    print("Overview: \(x.overview)")
                    print("Poster Path: \(x.poster_path ?? "is empty")")
                    print("\n")
                }
                
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
    // MARK: FETCH Upcoming Movies
    func fetchUpcomingMovies() {
        
        let upcomingMovieRequest = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1"
        
        AF.request( upcomingMovieRequest ).responseJSON { response in
            
            
            guard let json = response.data else {
                print("Upcoming movie response is nil ")
                return
            }
            
            do {
                let movies = try self.decoder.decode(UpcomingSchema.self, from: json)
                
                self.upcomingMovies = movies.results
                
                
            } catch {
                print(error)
            }
            
            
            
            
        }
        
        
    }
    
    
}


// MARK: Actors
extension MovieStore {
    
    // MARK: GET MOVIE CREDITS
    // Get the credits for a movie to fill up the actors view
    func fetchMovieCreditsForMovie(id: Int) {
        
        let creditsRequest = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)&language=en-US"
        
        AF.request( creditsRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let movieCredits = try self.decoder.decode(MovieCredits.self, from: json)
                
                self.movieCast = movieCredits.cast
                print("cast count: \(self.movieCast.count)")
                for x in self.movieCast {
                    print("Actor: \(x)")
                    print(x.name)
                    print("Character: " + x.character)
                    print("Popularity: " + "\(x.popularity)")
                    print("KnownFor: " + x.known_for_department)
                    print("ID: " + "\(x.id)")
                    print("\n")
                }
                
                
                for x in movieCredits.crew {
                    if x.job == "Director" {
                        print("Crew - name: \(x.name), job: \(x.job)")
                        self.director = x.name
                    }
                }
                
            } catch {
                print(error)
            }
            
            
            self.getImagesForActor()
        }
        
    }
    
    
    // Get Images for Actor
    func getImagesForActor() {
        
        for actor in self.movieCast {
            let imageRequest = "https://api.themoviedb.org/3/person/\(actor.id)/images?api_key=ebccbee67fef37cc7a99378c44af7d33"
            AF.request( imageRequest ).responseJSON { response in
                
                guard let json = response.data else {
                    print("No response for Actor image request ")
                    return }
                
                
                do {
                    let results = try self.decoder.decode(ActorSchema.self, from: json)
                    
                    for profileOne in results.profiles {
                        
                        for profileTwo in results.profiles {
                            // check for most voted for image && set path to actor id
                            if profileOne.vote_average > profileTwo.vote_average {
                                
                                guard let imagePath = profileOne.file_path else { return }
                                
                                self.actorImageProfiles[actor.id] = imagePath
                                
                            } else {
                                guard let imagePath = profileTwo.file_path else { return }
                                
                                self.actorImageProfiles[actor.id] = imagePath
                            }
                        }
                            
                    }
                    print("profile in actorImageProfile count = \(self.actorImageProfiles.count)")
                } catch {
                    print(error)
                }
            }
        }
    }

    // MARK: GET Movie & TV Credits for Actor
    func fetchCreditsFor(actor: Int) {
        
        let creditsRequest = "https://api.themoviedb.org/3/person/\(actor)/combined_credits?api_key=\(apiKey)&language=en-US"
        AF.request( creditsRequest ).responseJSON { response in
            guard let json = response.data else { return }
            do {
                // decode credits 
                let decodedCredits = try self.decoder.decode(ActorCredits.self, from: json)
                
                self.actorCredits = decodedCredits.cast
                
                print("ActorCredits")
                for z in decodedCredits.cast {
                    print(z.title ?? "")
                    print(z.name ?? "")
                    print(z.media_type) 
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: GET Details for Actor
    func fetchDetailsForActor(id: Int ) {
        // https://developers.themoviedb.org/3/people/get-person-details
        
        let detailsRequest = "https://api.themoviedb.org/3/person/\(id)?api_key=\(apiKey)&language=en-US"
        
        AF.request( detailsRequest ).responseJSON { response in
            guard let json = response.data else { return }
            do {
                let details = try self.decoder.decode(ActorDetails.self, from: json)
                
       
                self.actorDetails.append(details)
                    
 
            } catch {
                print(error)
            }
        }
    }
    
    
}


// MARK: Search
extension MovieStore {
    
    // MARK: GET Search Results (MOVIE)
    func fetchResultsForMovie(query: String) {
        
        let searchMovieRequest = "https://api.themoviedb.org/3/search/movie?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&query=\(query)&page=1&include_adult=false"
        
        AF.request( searchMovieRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let searchResults = try self.decoder.decode(MovieSearch.self, from: json)
                
                guard let results = searchResults.results else {
                    print("No movie results found")
                    return }
                
                self.movieSearchResults = results
                
                print("Movie Query Result Count:  \(self.movieSearchResults.count)")
                for movie in self.movieSearchResults {
                    print(movie.title)
                    
                }
                
            } catch {
                print(error)
            }

        }
        
    }
    
    
    // Get results from movie search
    func fetchResultsFromMovie(search: String) -> [MovieSearchResults] {
        
        var movieSearchResults = [MovieSearchResults]()
        
        let searchMovieRequest = "https://api.themoviedb.org/3/search/movie?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&query=\(search)&page=1&include_adult=false"
        
        AF.request( searchMovieRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let searchResults = try self.decoder.decode(MovieSearch.self, from: json)
                
                guard let results = searchResults.results else {
                    print("No movie results found")
                    return }
                
                movieSearchResults = results
                
                print("Movie Query Result Count:  \(self.movieSearchResults.count)")
                for movie in self.movieSearchResults {
                    print(movie.title)
                    
                }
                
            } catch {
                print(error)
            }

        }
        
        return movieSearchResults
        
    }
    
    
    // MARK: GET Search Results (ACTOR)
    func fetchResultsForActor(query: String) {
        
    }
    
}


// MARK: POST :: DELETE
extension MovieStore {
    
}

// MARK: GET Genres
extension MovieStore { 
    
    func getGenres() {
        let genreRequest = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US"
        
        AF.request( genreRequest ).responseJSON { response in
            
            guard let json = response.data else {
                print("Genre List not found")
                return
            }
            do {
                let results = try self.decoder.decode(GenreArray.self, from: json)
                
                for genre in results.genres {
                    
                    self.genreDictionary[genre.id] = genre.name
                }

            } catch {
                print(error)
            }
            
        }
    }
    
    func extractGenres(from IDs: [Int]) -> [String] {
        var genreNames = [String]()
        print("T1: " + "\(IDs)")
        for id in IDs {
            print("T1: ID = \(id)")
            print("T1: genreDict[\(id)] = \(genreDictionary[id] ?? "nil") " )
            
            if let genre = genreDictionary[id] {
                print(genreDictionary[id] ?? "is empty ")
                genreNames.append(genre)
            }

        }
        
        print(#function)
        
        for name in genreNames {
            print("T1" + name)
        }
        return genreNames
    }
    
    func pullGenresFromServer() -> [Genre] {
        var fetchedGenres: [Genre] = []
        let genreRequest = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US"
        AF.request( genreRequest ).responseJSON { response in
            
            guard let json = response.data else {
                print("Genre List not found")
                return
            }
            do {
                let results = try self.decoder.decode(GenreArray.self, from: json)

                fetchedGenres = results.genres
                
            } catch {
                print(error)
            }
            
        }

        return fetchedGenres
    }
    
}
