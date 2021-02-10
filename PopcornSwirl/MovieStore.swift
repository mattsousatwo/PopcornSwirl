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
    let ratingsStore = MovieRatingStore()
    
    let movieCD = MoviesStore() // manage Movies: CoreData - to replace ratingsStore
    
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

    
    // WatchProviders
    @Published var watchProviders: PurchaseLink?
    
    
    lazy var decoder = JSONDecoder() // used to decode json data
    
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
        
        let recommendedRequest = "https://api.themoviedb.org/3/movie/\(id)/recommendations?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US&page=1"
        
        AF.request( recommendedRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let recomendations = try self.decoder.decode(Recommendation.self, from: json)
                guard let results = recomendations.results else { return }
                self.recommendedMovies = results
                
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
        
        let upcomingMovieRequest = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US&page=1"
        
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
        
        let creditsRequest = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US"
        
        AF.request( creditsRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let movieCredits = try self.decoder.decode(MovieCredits.self, from: json)
                
//                self.movieCast = movieCredits.cast
                
                self.movieCast.limitedAppend(contents: movieCredits.cast)
            
                
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
        var movieCount = false
        if movieCast.count > 25 {
            movieCount = true
        } else {
            movieCount = false
        }
        for i in (movieCount ? 0..<25 : 0..<movieCast.count) {
            actors.limited(append: movieCast[i])
//            actorsStore.createActor(name: movieCast[i].name,
//                                    bio: nil,
//                                    id: Double(movieCast[i].id),
//                                    imagePath: movieCast[i].profile_path)
        }
        
//        actorsStore.saveActorsIn(actors)
        
        
        
//        for i in 0..<24 {
//            print("extractMovieCast() : for \(i) in 0..<24")
//            if i <= 24 {
//                actors.append(movieCast[i])
////                self.castStore.createCastMember(actorID: Double(movieCast[i].id), movieID: Double(id))
//                print("extractMovieCast() : loop { \(i) }")
////                self.actorsStore.createActor(name: movieCast[i].name,
////                                             bio: nil,
////                                             id: Double(movieCast[i].id),
////                                             imagePath:  movieCast[i].profile_path)
//
//            }
//        }
        print("extractedMovieCast.count: \(actors.count)")
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
        
        let creditsRequest = "https://api.themoviedb.org/3/person/\(actor)/combined_credits?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US"
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
    enum CreditExtractionType: String {
        case movie = "movie", tv = "tv"
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
                if movie.media_type == CreditExtractionType.movie.rawValue {
                    credits.append(movie)
                }
            }
        case .tv:
            for series in actorCredits {
                if series.media_type == CreditExtractionType.tv.rawValue {
                    credits.append(series)
                }
            }
        }
        return credits
    }
    
    // MARK: GET Details for Actor
    func fetchDetailsForActor(id: Int ) {
        // https://developers.themoviedb.org/3/people/get-person-details
        let actor = actorsStore.fetchActorWith(id: id)
        
        let detailsRequest = "https://api.themoviedb.org/3/person/\(id)?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US"
        
        AF.request( detailsRequest ).responseJSON { response in
            guard let json = response.data else { return }
            do {
                let details = try self.decoder.decode(ActorDetails.self, from: json)
                self.actorDetails.append(details)
                
                self.actorsStore.update(actor: actor,
                                   id: Double(id),
                                   imagePath: details.profile_path ?? "",
                                   name: details.name,
                                   deathDate: details.deathday ?? nil ,
                                   birthDate: details.birthday ?? nil,
                                   birthPlace: details.place_of_birth ?? nil,
                                   bio: details.biography)
                print("updatedActor: \(actor.name ?? "nil"), \(actor.id), \(actor.imagePath ?? "nil"), \(actor.deathDate ?? "nil"), \(actor.birthDate ?? "nil"), \(actor.birthPlace ?? "nil"), \(actor.biography ?? "nil")")
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
    
    
    // Return array of results for movie search
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
        
        let searchMovieRequest = "https://api.themoviedb.org/3/search/movie?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US&query=\(MovieStoreKey.apiKey.rawValue)&page=1&include_adult=false"
        
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



// MARK: GET Genres
extension MovieStore { 
    
    func getGenres() {
        let genreRequest = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US"
        
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
        for id in IDs {
            if let genre = genreDictionary[id] {
                genreNames.append(genre)
            }
        }
        return genreNames
    }
    
}


// MARK: - Purchase Movie Links
extension MovieStore {
    
    
    // Not picking up any results yet request is working 
    func fetchPurchaseMovieLinks(id: Int) {
        
        //        let request = "https://api.themoviedb.org/3/movie/\(id)/watch/providers?api_key=\(apiKey)"
        let request = "https://api.themoviedb.org/3/movie/\(id)/watch/providers?api_key=\(MovieStoreKey.apiKey.rawValue)&watch_region=US"
        
        AF.request( request ).responseJSON { response in
            
            guard let json = response.data else {
                print("No Links for Movie Purchase Found")
                return
            }
            
            do {
                
                let results = try self.decoder.decode(WatchProviders.self, from: json)
                
                guard let resultsResponse = results.results else { return }
                guard let usWatchProviders = resultsResponse.us else { return }
                
                print("USProviders: \(usWatchProviders)")
                
                self.watchProviders = usWatchProviders 
                
                
            } catch {
                print(error)
            }
            
        }
    }
    
    // Fetch and return an array of watch provider links
    func extractWatchProvidersFor(id movieID: Int) -> PurchaseLink {
        var links = PurchaseLink()
        
        if watchProviders == nil {
            fetchPurchaseMovieLinks(id: movieID)
        }
        
        if let watchProviders = watchProviders {
            links = watchProviders
        }
        return links
    }
    
    
}


// Get IDs for movie
extension MovieStore {
    
    // Getting IDs being used to then fetch Ratings with
    func extractIDsFor(_ type: ScrollBarType, id searchID: Int = 0 ) -> [Int] {
        var ids: [Int] = []
        
        switch type {
        case .popularMovie:
            if popularMovies.count == 0 {
                fetchPopularMovies()
            }
            for movie in popularMovies {
                ids.append(movie.id)
            }
        case .upcommingMovie:
            if upcomingMovies.count == 0 {
                fetchUpcomingMovies()
            }
            for movie in upcomingMovies {
                ids.append(movie.id)
            }
        case .recommendedMovie:
            if recommendedMovies.count == 0 {
                fetchRecommendedMoviesForMovie(id: searchID)
            }
            for movie in recommendedMovies {
                if let id = movie.id {
                    ids.append(id)
                }
            }
            
        case .actors:
            
            if movieCast.count == 0 {
                fetchMovieCreditsForMovie(id: searchID)
            }
            for i in 0..<movieCast.count {
                if i <= 24 {
                    ids.append(movieCast[i].id)
                }
            }
            
            
        case .actorMovie:
            if searchID != 0 {
                if actorCredits.count == 0 {
                    fetchCreditsFor(actor: searchID)
                }
                for actor in actorCredits {
                    if actor.media_type == CreditExtractionType.movie.rawValue {
                        if let id = actor.id {
                            ids.append(id)
                        }
                    }
                }
            }
        case .actorTV:
            if searchID != 0 {
                if actorCredits.count == 0 {
                    fetchCreditsFor(actor: searchID)
                }
                for credit in actorCredits {
                    if credit.media_type == CreditExtractionType.tv.rawValue {
                        if let id = credit.id {
                            ids.append(id)
                        }
                    }
                }
            }
        }
        
        return ids
    }
    
    // Fetching Ratings by bar type
    func ratingsForBar(type: ScrollBarType, id searchID: Int = 0 ) -> [Rating] {
        var ratings: [Rating] = []
        
        switch type {
        case .popularMovie:
            let popularMovieRatingIDs = extractIDsFor(.popularMovie)
            ratings = ratingsStore.fetchAllRatingsUsingIDs(in: popularMovieRatingIDs, predicate: .movie)
        case .upcommingMovie:
            let upcomingMovieRatingIDs = extractIDsFor(.upcommingMovie)
            ratings = ratingsStore.fetchAllRatingsUsingIDs(in: upcomingMovieRatingIDs, predicate: .movie)
        case .recommendedMovie:
            let reccomendedMovieRatingIDs = extractIDsFor(.recommendedMovie, id: searchID)
            ratings = ratingsStore.fetchAllRatingsUsingIDs(in: reccomendedMovieRatingIDs, predicate: .movie)
            
        case .actors:
            let actorsRatingIDs = extractIDsFor(.actors, id: searchID)
            ratings = ratingsStore.fetchAllRatingsUsingIDs(in: actorsRatingIDs, predicate: .actor)
        case .actorMovie:
            let actorMovieIDs = extractIDsFor(.actorMovie, id: searchID)
            ratings = ratingsStore.fetchAllRatingsUsingIDs(in: actorMovieIDs, predicate: .movie)
        case .actorTV: // MARK: Not working 
            let actorTVSeriesIDs = extractIDsFor(.actorTV, id: searchID)
            ratings = ratingsStore.fetchAllRatingsUsingIDs(in: actorTVSeriesIDs, predicate: .tv)
        }
        
        return ratings
        
    }
    
}



// MARK: - MOVIES: COREDATA
extension MovieStore {
    
    
    // Get all Movies for bar type - use extractIDsFor
    func movieForBar(_ type: ScrollBarType, id searchID: Int = 0) -> [Movie] {
        var movies: [Movie] = []
        switch type {
        case .popularMovie:
            let popularMovieIDs = extractIDsFor(.popularMovie)
            let ids = popularMovieIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
        case .upcommingMovie:
            let upcomingMovieIDs = extractIDsFor(.upcommingMovie)
            let ids = upcomingMovieIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
        case .recommendedMovie:
            let reccomendedMovieIDs = extractIDsFor(.recommendedMovie, id: searchID)
            let ids = reccomendedMovieIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
            
        case .actors: // Change to Actors
            
            
            let actorIDs = extractIDsFor(.actors, id: searchID)
            let ids = actorIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
            
            
        case .actorMovie:
            let actorMovieIDs = extractIDsFor(.actorMovie, id: searchID)
            let ids = actorMovieIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
        case .actorTV:
            let actorTVIDs = extractIDsFor(.actorTV, id: searchID)
            let ids = actorTVIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
        }
        return movies
    }
}


enum MovieStoreKey: String {
    case apiKey = "ebccbee67fef37cc7a99378c44af7d33" // API Key
    case imageURL = "https://image.tmdb.org/t/p/original" // used as base for movie images
}
