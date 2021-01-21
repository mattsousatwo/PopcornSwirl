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
    
    // Coredata
    let castStore = CastStore() // used to manage cast dict
    let actorsStore = ActorsStore() // used to manage the actors within cast list
    
    
    // Movie Stores
    @Published var popularMovies = [PopMovie]() // all popular movies
    @Published var movieCast = [MovieCast]() // cast for movie
    @Published var director = String() // crew for movie - director
    @Published var recommendedMovies = [RecommendedMovie]() // all recommended movies by movie ID
    @Published var movieSearchResults = [MovieSearchResults]()
    @Published var upcomingMovies = [UpcomingMovie]()
    @Published var actorImageProfiles = [Int : String]() // Stores actor images by ID
    @Published var genreDictionary = [Int: String]() // Stores genres
    
    // ActorDetail
    @Published var actorCredits = [ActorCreditsCast]()
    @Published var actorDetails = [ActorDetails]()
    
    
    @Published var ml = [MovieLink]()
    @Published var movieLinks = [MovieLinkResult]()
    
    
    
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
                
            } catch {
                print(error)
            } // do / catch

        } // request
        
    } // fetchPopularMovies
    
    // Get movies after fetchPopularMovies is finished retrieving data
    func extractPopularMovies() -> [PopMovie] {
        var movies = [PopMovie]()
        
        if popularMovies.count == 0 {
            fetchPopularMovies()
        }
        
        for movie in popularMovies {
            movies.append(movie)
        }

        return movies
    } // extractPopularMovies
 
    // MARK: Get Reccomended Movies for movie
    func fetchRecommendedMoviesForMovie(id: Int) {
        
        let recommendedRequest = "https://api.themoviedb.org/3/movie/\(id)/recommendations?api_key=\(apiKey)&language=en-US&page=1"
        
        AF.request( recommendedRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let recomendations = try self.decoder.decode(Recommendation.self, from: json)
                
                self.recommendedMovies = recomendations.results
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
    // Get movies after fetchPopularMovies is finished retrieving data
    func extractRecomendedMovies(id: Int) -> [RecommendedMovie] {
        var movies = [RecommendedMovie]()
        
        if recommendedMovies.count == 0 {
            fetchRecommendedMoviesForMovie(id: id)
        }

        for movie in recommendedMovies {
            movies.append(movie)
        }

        return movies
    } // fetchPopularMovies
    
    
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
    
    // Get All Upcoming Movies after movies have been fetched 
    func extractUpcomingMovies() -> [UpcomingMovie] {
        var movies = [UpcomingMovie]()
        if upcomingMovies.count == 0 {
            fetchUpcomingMovies()
        }
        for movie in upcomingMovies {
            movies.append(movie)
        }
        return movies
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
                
                for x in movieCredits.crew {
                    if x.job == "Director" {
                        self.director = x.name
                    }
                }
                
                
                // save to coredata
//                if self.movieCast.count != 0 {
//                    for actor in self.movieCast {
//                        self.castStore.createCastMember(actorID: Double(actor.id), movieID: Double(id))
//                    }
//                }
                
            } catch {
                print(error)
            }
            
            
            self.getImagesForActor()
        }
        
    }
    
    // MARK: Extract Movie Cast after they have been fetched
    func extractMovieCast(id: Int) -> [MovieCast] {
        var actors = [MovieCast]()
        if movieCast.count == 0 {
            fetchMovieCreditsForMovie(id: id)
        }
        for i in 0..<movieCast.count {
            if i <= 24 {
                actors.append(movieCast[i])
                self.castStore.createCastMember(actorID: Double(movieCast[i].id), movieID: Double(id))
//                self.actorsStore.createActor(name: movieCast[i].name,
//                                             bio: nil,
//                                             id: Double(movieCast[i].id),
//                                             image: nil )
//
                if let profilePath = movieCast[i].profile_path {
                    if let url = URL(string: imageURL + profilePath) {
                        let loader = ImageLoader(url: url)
                        if let loadedImage = loader.image {
                                
                            self.actorsStore.createActor(name: movieCast[i].name,
                                                         bio: nil,
                                                         id: Double(movieCast[i].id),
                                                         image:  loadedImage)
                                      
                        }
                    }
                }
            }
        }
        return actors
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
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: Extract Actor Images after image paths have been fetched
    func extractActorImageProfiles(id: Int) -> [Int : String] {
        var imageDict = [Int : String]()
        if actorImageProfiles.count == 0 {
            fetchMovieCreditsForMovie(id: id)
            getImagesForActor()
        }
        for (id, path) in actorImageProfiles {
            
            imageDict[id] = path
        }
//        print("Test 3 - imageDict: \(imageDict.count)")
        return imageDict
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

                
            } catch {
                print(error)
            }
        }
    }
    
    // Used to extract actor credits depending on type
    enum CreditExtractionType {
        case movie, tv
    }
    
    // Extract all credits depending on type
    func extractCreditsFor(actorID: Int, type: CreditExtractionType) -> [ActorCreditsCast] {
        var credits: [ActorCreditsCast] = []
        if actorCredits.isEmpty == true {
            fetchCreditsFor(actor: actorID)
        }
        switch type {
        case .movie:
            for movie in actorCredits {
                if movie.media_type == "movie" {
                    credits.append(movie)
                }
            }
        case .tv:
            for series in actorCredits {
                if series.media_type == "tv" {
                    credits.append(series)
                }
            }
        }
        return credits
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
    
    
    
    func extractMovieSearchResults() -> [MovieSearchResults] {
        var searchResults = [MovieSearchResults]()
        for movie in self.movieSearchResults {
            searchResults.append(movie)
        }
        return searchResults
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


// MARK: - Purchase Movie Links
extension MovieStore {
    
    
    // Not picking up any results yet request is working 
    func fetchPurchaseMovieLinks(id: Int) {
        
//        let request = "https://api.themoviedb.org/3/movie/\(id)/watch/providers?api_key=\(apiKey)"
        let request = "https://api.themoviedb.org/3/movie/\(id)/watch/providers?api_key=\(apiKey)&watch_region=US"
        
        AF.request( request ).responseJSON { response in
            
            guard let json = response.data else {
                print("No Links for Movie Purchase Found")
                return
            }
            
            do {
                print("Test 4 - FetchPurchaseMovieLinks() ")
                let results = try self.decoder.decode(MovieLink.self, from: json)
                
                
                self.ml = [results]
                print("Test 4 - results.count = \(results)")
                
                for x in self.ml {
                    print("Test 4 - \(x)")
                }
                
                
                
                // MovieLinkResults
                guard let linkResults = results.results else { return }
                guard let usLinks = linkResults["US"] else { return }
                guard let links = usLinks else { return }
                
                
                
                for link in links {
                    
                    print( "Test 4 - \(print(link))" )
                }
                
                
                
//                let country  = results.results["US"]
                
                
//                self.movieLinks = results.result
//                if let country = country {
//                    for object in country {
//                        print("Test 4 - \(object)")
//                    }
//                }
                
//                for object in self.movieLinks {
//                    print("Test 4 - \(object.country ?? "")")
//                }
//
                
                
            } catch {
                print(error)
            }

            
        }
    }
    
    
}
