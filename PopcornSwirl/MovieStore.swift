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
    /// used to manage the actors within cast list
    let actorsStore = ActorsStore()
    /// Used to manage TV Series
    let seriesStore = SeriesStore()
    /// Used to manage Movies in Coredata
    let movieCD = MoviesStore()
    
    // Movie Stores
    @Published var popularMovies = [PopMovie]() // all popular movies
    @Published var movieCast = [MovieCast]() // cast for movie
    @Published var director = String() // crew for movie - director
    @Published var recommendedMovies = [RecommendedMovie]() // all recommended movies by movie ID
    @Published var movieSearchResults = [MovieSearchResults]()
    @Published var upcomingMovies = [UpcomingMovie]()
    @Published var actorImageProfiles = [Int : String]() // Stores actor images by ID

    
    // ActorDetail
    @Published var actorCredits = [ActorCreditsCast]()
    @Published var actorDetails = [ActorDetails]()

    // Series Credits
    @Published var tvSeriesCast = [TVSeriesCast]() // Cast for tvSeries
    @Published var similarSeries = [SimilarSeries]()
    @Published var seriesDetail = SeriesDetail()
    
    
    
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
            removeOldMovies(from: .popular)
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
            
            let movie = self.movieCD.fetchMovie(uuid: id)
            if let recMovieString = self.movieCD.encodeReccomendedMovies(self.recommendedMovies) {
             
                self.movieCD.update(movie: movie, recommendedMovies: recMovieString)
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
            
            
            guard let json = response.data else { return }
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
            removeOldMovies(from: .upcoming)
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
    /// Get the credits for a movie to fill up the actors view
    func fetchMovieCreditsForMovie(id: Int) {
        
        let creditsRequest = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US"
        
        let movie = movieCD.fetchMovie(uuid: id)
        
        AF.request( creditsRequest ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let movieCredits = try self.decoder.decode(MovieCredits.self, from: json)
                if let cast = movieCredits.cast {
                    self.movieCast.limitedAppend(contents: cast)
                }
                
                for member in movieCredits.crew {
                    if member.job == "Director" {
                        if member.name != movie.director ||
                            movie.director == "" {
                            self.movieCD.update(movie: movie,
                                                director: member.name)
                        }
                    }
                }
                
            } catch {
                print(error)
            }
            
            guard let movieCastAsString = self.movieCD.encodeCast(self.movieCast) else { return }
            
            self.movieCD.update(movie: movie,
                                cast: movieCastAsString)
            
            if let director = movie.director {
                self.director = director
            }
        }
        
        self.getImagesForActor()
    }
    
    /// Pull value from @Published director property
    func extractDirector(id: Int) -> String {
        var tempString = ""
        
        if director == "" {
            fetchMovieCreditsForMovie(id: id)
        } else {
            tempString = director
        }
        if tempString == "" {
            let movie = movieCD.fetchMovie(uuid: id)
            if let savedDirector = movie.director {
                tempString = savedDirector
            }
        }
        
        return tempString
        
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
        }

        
        return actors
    }
    
    
    // Get Images for Actor
    func getImagesForActor() {
        
        for castMember in self.movieCast {
            let imageRequest = "https://api.themoviedb.org/3/person/\(castMember.id)/images?api_key=ebccbee67fef37cc7a99378c44af7d33"
            AF.request( imageRequest ).responseJSON { response in
                
                guard let json = response.data else { return }
                do {
                    let results = try self.decoder.decode(ActorSchema.self, from: json)
                    
                    let actor = self.actorsStore.fetchActorWith(id: castMember.id)
                        
                    
                    for profileOne in results.profiles {
                        
                        for profileTwo in results.profiles {
                            // check for most voted for image && set path to actor id
                            if profileOne.vote_average > profileTwo.vote_average {
                                
                                guard let imagePath = profileOne.file_path else { return }
                                
                                // Save to coredata
                                self.actorsStore.update(actor: actor, imagePath: imagePath)
                                
                                self.actorImageProfiles[castMember.id] = imagePath
                                
                            } else {
                                guard let imagePath = profileTwo.file_path else { return }
                                
                                // Save to coredata
                                self.actorsStore.update(actor: actor, imagePath: imagePath)
                                
                                self.actorImageProfiles[castMember.id] = imagePath
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
//            getImagesForActor()
        }
        for (id, path) in actorImageProfiles {
            
            imageDict[id] = path
        }

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
                guard let cast = decodedCredits.cast else { return }
                self.actorCredits = cast

                
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Can add actors TV & Movie credits here
    // Extract all credits depending on type  
    func extractCreditsFor(actorID: Int, type: CreditExtractionType) -> [ActorCreditsCast] {
        var credits: [ActorCreditsCast] = []
        if actorCredits.isEmpty == true {
            fetchCreditsFor(actor: actorID)
        }
        
        if actorCredits.isEmpty != true {
            let actor = actorsStore.fetchActorWith(id: actorID)
            let credits = actorsStore.encodeActorCredits(actorCredits)
            actorsStore.update(actor: actor, credits: credits)
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
                
                guard let results = searchResults.results else { return }
                self.movieSearchResults = results                
            } catch {
                print(error)
            }

        }
        
    }
    
    
    // Return array of results for movie search
    func extractMovieSearchResults() -> [[MovieSearchResults]] {
        var searchResults = [[MovieSearchResults]]()
        if self.movieSearchResults.count != 0 {
            let dividedCount = movieSearchResults.count / 2
            if dividedCount >= 1 {
                searchResults = movieSearchResults.divided(into: 2)
            }
        }
        return searchResults
    }

    
}



// MARK: - Purchase Movie Links
extension MovieStore {
    
    
    // Not picking up any results yet request is working 
    func fetchPurchaseMovieLinks(id: Int) {
        
        //        let request = "https://api.themoviedb.org/3/movie/\(id)/watch/providers?api_key=\(apiKey)"
        let request = "https://api.themoviedb.org/3/movie/\(id)/watch/providers?api_key=\(MovieStoreKey.apiKey.rawValue)&watch_region=US"
        
        AF.request( request ).responseJSON { response in
            
            guard let json = response.data else { return }
            
            do {
                
                let results = try self.decoder.decode(WatchProviders.self, from: json)
                
                guard let resultsResponse = results.results else { return }
                guard let usWatchProviders = resultsResponse.us else { return }
                
                self.watchProviders = usWatchProviders 
                let movie = self.movieCD.fetchMovie(uuid: id)
                
                if let watchProviderString = self.movieCD.encodeWatchProviders(usWatchProviders) {
                    self.movieCD.update(movie: movie, watchProviders: watchProviderString)
                }
                
                
                
                
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
    
    
    /// Check if movie in category is still in the Movie DBs category of the same type
    func removeOldMovies(from type: MovieCategory) {

        switch type {
        case .popular:
            let popularIDs = popularMovies.map({ $0.id })
            if popularIDs.count != 0 {
                movieCD.fetchMovies(.popular)
                let savedPopularMovies = movieCD.popularMovies.map({ $0.uuid })
                for i in 0..<savedPopularMovies.count {
                    if popularIDs.contains( Int(savedPopularMovies[i]) ) == false {
                        if let movie = movieCD.popularMovies.first(where: { $0.uuid == savedPopularMovies[i] }) {
                            movie.update(category: MovieCategory.none)
                        }
                    }
                }
            }
        case .upcoming:
            let upcomingIDs = upcomingMovies.map({ $0.id })
            if upcomingIDs.count != 0 {
                movieCD.fetchMovies(.upcoming)
                let savedUpcomingMovies = movieCD.upcomingMovies.map({ Int($0.uuid) })
                for i in 0..<savedUpcomingMovies.count {
                    if upcomingIDs.contains( savedUpcomingMovies[i] ) == false {
                        if let movie = movieCD.upcomingMovies.first(where: { $0.uuid == Double(savedUpcomingMovies[i]) } ) {
                            movie.update(category: MovieCategory.none)
                        }
                    }
                }
            }
        default:
            break
        }
    }
    
    
    /// Handles which movie IDs should be used to fetch movies in ScrollBar via moiveForBar(type: )
    func extractIDsFor(_ type: ScrollBarType, id searchID: Int = 0 ) -> [Int] {
        var ids: [Int] = []
        
        switch type {
        case .popularMovie:
            if popularMovies.count == 0 {
                fetchPopularMovies()
            }
            if popularMovies.count != 0 {
                for movie in popularMovies {
                    ids.append(movie.id)
                    
                    let fetchedMovie = movieCD.fetchMovie(uuid: movie.id)
                    let genresString = movieCD.encodeGenres(movie.genre_ids)
                    
                                    movieCD.update(movie: fetchedMovie,
                                                   category: .popular,
                                                   title: movie.title,
                                                   overview: movie.overview,
                                                   imagePath: movie.poster_path,
                                                   genres: genresString,
                                                   releaseDate: movie.release_date,
                                                   voteAverage: movie.vote_average)
                    
                }
            }
            
            
        case .upcomingMovie:
            if upcomingMovies.count == 0 {
                fetchUpcomingMovies()
            }
            for movie in upcomingMovies {
                ids.append(movie.id)
                
                let fetchedMovie = movieCD.fetchMovie(uuid: movie.id)
                let genresString = movieCD.encodeGenres(movie.genre_ids)
                
                movieCD.update(movie: fetchedMovie,
                               category: .upcoming,
                               title: movie.title,
                               overview: movie.overview,
                               imagePath: movie.poster_path,
                               genres: genresString,
                               releaseDate: movie.release_date,
                               voteAverage: movie.vote_average)
            }

            
            
        case .recommendedMovie:
            if recommendedMovies.count == 0 {
                fetchRecommendedMoviesForMovie(id: searchID)
            }
            for movie in recommendedMovies {
                if let id = movie.id {
                    ids.append(id)
                    
                    let fetchedMovie = movieCD.fetchMovie(uuid: id)
                    let genresString = movieCD.encodeGenres(movie.genre_ids)
                    
                    movieCD.update(movie: fetchedMovie,
                                   title: movie.title,
                                   overview: movie.overview,
                                   imagePath: movie.poster_path,
                                   genres: genresString,
                                   releaseDate: movie.release_date,
                                   rating: movie.vote_average)
                }
            }
            
            if recommendedMovies.count == 0 {
                let movie = movieCD.fetchMovie(uuid: searchID)
                if let recommended = movie.recommendedMovies {
                    if let recommendedMovieList = movieCD.decodeReccomendedMovies(recommended) {
                        for movie in recommendedMovieList {
                            if let id = movie.id {
                                ids.append(id)
                            }
                        }
                    }
                }
            }
            
        case .actors:
            if movieCast.count == 0 {
                fetchMovieCreditsForMovie(id: searchID)
            }
            for i in 0..<movieCast.count {
                if i <= 24 {
                    let castMember = movieCast[i]
                    ids.append(castMember.id)
                    
                    let actor = actorsStore.fetchActorWith(id: castMember.id)
                    actorsStore.update(actor: actor,
                                       id: Double(castMember.id),
                                       imagePath: castMember.profile_path ?? "",
                                       name: castMember.name)
                    
                }
            }
            
            // if cannot fetch through TMDB
            if movieCast.count == 0 {
                let movie = movieCD.fetchMovie(uuid: searchID)
                if let cast = movie.cast {
                    if let decodedCast = movieCD.decodeCast(cast) {
                        for i in 0..<decodedCast.count {
                            if i >= 24 {
                                ids.append(decodedCast[i].id)
                            }
                        }
                    }
                }
            }
        case .actorMovie:
            if searchID != 0 {
                if actorCredits.count == 0 {
                    fetchCreditsFor(actor: searchID)
                }
                // load from TMDB
                for movie in actorCredits {
                    if movie.media_type == CreditExtractionType.movie.rawValue {
                        if let id = movie.id {
                            ids.append(id)
                            
                            let fetchedMovie = movieCD.fetchMovie(uuid: id)
                            let genresString = movieCD.encodeGenres(movie.genre_ids)
                            
                            movieCD.update(movie: fetchedMovie,
                                           title: movie.title ?? "",
                                           overview: movie.overview,
                                           imagePath: movie.poster_path ?? "",
                                           genres: genresString,
                                           releaseDate: movie.release_date ?? "",
                                           rating: movie.vote_average)
                        }
                    }
                }
                

                // Load from coredata
                if actorCredits.count == 0 {

                    let actor = actorsStore.fetchActorWith(id: searchID)
                    if let encodedCredits = actor.credits {
                        if let credits = actorsStore.decodeActorCredits(encodedCredits, .movie) {
                            for credit in credits {
                                    if let id = credit.id {
                                        ids.append(id)
                                }
                            }
                        }
                    }

                }
                
            }
        case .actorTV:
            if searchID != 0 {
                if actorCredits.count == 0 {
                    fetchCreditsFor(actor: searchID)
                }
                for series in actorCredits {
                    if series.media_type == CreditExtractionType.tv.rawValue {
                        if let id = series.id {
                            ids.append(id)
                            
                            // MARK: UPDATE SERIES HERE
                            let fetchedSeries = seriesStore.fetchSeries(uuid: id)
                            
                            seriesStore.update(series: fetchedSeries,
                                               imagePath: series.poster_path ?? "",
                                               overview: series.overview,
                                               rating: series.vote_average,
                                               releaseDate: series.release_date ?? "",
                                               title: series.title ?? "",
                                               uuid: Double(id))

                            
                        }
                    }
                }
            }
            
            // Load from coredata
            if actorCredits.count == 0 {

                let actor = actorsStore.fetchActorWith(id: searchID)
                if let encodedCredits = actor.credits {
                    if let credits = actorsStore.decodeActorCredits(encodedCredits, .tv) {
                        for credit in credits {
                                if let id = credit.id {
                                    ids.append(id)
                            }
                        }
                    }
                }

            }
            
            
        }
        
        
        return ids
    }
     
}



// MARK: - MOVIES: COREDATA
extension MovieStore {
    
    
    // Get all Movies for bar type - use extractIDsFor
    func moviesForBar(_ type: ScrollBarType, id searchID: Int = 0) -> [Movie] {
        var movies: [Movie] = []
        switch type {
        case .popularMovie:
            movieCD.fetchMovies(.popular)
            if movieCD.popularMovies.count != 0 {
                movies = movieCD.popularMovies
            }
            
            
        case .upcomingMovie:
            movieCD.fetchMovies(.upcoming)
            if movieCD.upcomingMovies.count != 0 {
                movies = movieCD.upcomingMovies
            }
        case .recommendedMovie:
            let reccomendedMovieIDs = extractIDsFor(.recommendedMovie, id: searchID)
            let ids = reccomendedMovieIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
        case .actorMovie:
            let actorMovieIDs = extractIDsFor(.actorMovie, id: searchID)
            let ids = actorMovieIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
        case .actorTV:
            let actorTVIDs = extractIDsFor(.actorTV, id: searchID)
            let ids = actorTVIDs.map({ Double($0) })
            movies = movieCD.fetchMovies(uuids: ids)
        default:
            break
        }
        return movies
    }
    
    
    
}


// MARK: TV Credits (cast)
extension MovieStore {
    
    /// fetch credits for TV Series
    func fetchTVSeriesCredits(id: Int) {
        // https://developers.themoviedb.org/3/tv/get-tv-credits
        let tvSeriesCreditRequest = "https://api.themoviedb.org/3/tv/\(id)/credits?api_key=ebccbee67fef37cc7a99378c44af7d33&language=en-US"
        AF.request( tvSeriesCreditRequest ).responseJSON { response in
            guard let json = response.data else { return }
            do {
                let results = try self.decoder.decode(TVSeriesCreditSchema.self, from: json)
                self.tvSeriesCast = results.cast
                
                let series = self.seriesStore.fetchSeries(uuid: id)
                
                if let encodedCast = self.seriesStore.encodeTVSeriesCast(self.tvSeriesCast) {
                    self.seriesStore.update(series: series, cast: encodedCast)
                }
            } catch {
                print(error)
            }
        }
    }

    // Get all series
    func extractTVSeriesCredits(id: Int) -> [TVSeriesCast] {
        var cast = [TVSeriesCast]()
        if tvSeriesCast.count == 0 {
            fetchTVSeriesCredits(id: id)
        }
        cast.append(contentsOf: tvSeriesCast)
        return cast
    }
}


// MARK: Similar TV Shows
extension MovieStore {
    
    
    
    /// fetch similar tv shows
    func fetchSimilarSeriesForShow(id: Int) {
        // https://developers.themoviedb.org/3/tv/get-similar-tv-shows
        let similarSeriesRequest = "https://api.themoviedb.org/3/tv/\(id)/similar?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US&page=1"
        AF.request( similarSeriesRequest ).responseJSON { response in
            guard let json = response.data else { return }
            do {
                let results = try self.decoder.decode(SimilarSeriesSchema.self, from: json)
                self.similarSeries = results.results
                let series = self.seriesStore.fetchSeries(uuid: id)
                
                self.seriesStore.update(series: series,
                                        similarSeries: self.similarSeries)
                
                
                
            } catch {
                print(error)
            }
        }
    }
    
    
    // Get all similar series
    func extractSimilarSereis(id: Int) -> [SimilarSeries] {
        var series = [SimilarSeries]()
        if similarSeries.count == 0 {
            fetchSimilarSeriesForShow(id: id)
        }
        series.append(contentsOf: similarSeries)
        return series
    }
    
    
}


// MARK: TV Series Detail
extension MovieStore {
    
    /// Fetch Details for TV Series
    func fetchTVSeriesDetails(id: Int) {
        // https://developers.themoviedb.org/3/tv/get-tv-details
        let detailsRequest = "https://api.themoviedb.org/3/tv/\(id)?api_key=\(MovieStoreKey.apiKey.rawValue)&language=en-US"
        
        AF.request( detailsRequest ).responseJSON { response in
            guard let data = response.data else { return }
            do {
                let results = try self.decoder.decode(SeriesDetail.self, from: data)
                self.seriesDetail = results
                let series = self.seriesStore.fetchSeries(uuid: id)
                
                if let episodeCount = self.seriesDetail.number_of_episodes,
                   let seasonCount = self.seriesDetail.number_of_seasons {
                    self.seriesStore.update(series: series,
                                       seasonCount: Int16(seasonCount),
                                       episodeCount: Int16(episodeCount))
                    
                }
   
            } catch {
                print(error)
            }
        }
    }
    
    
    // Get TVSeriesDetails
    func extractDetailsFor(sereies id: Int) -> SeriesDetail {
        var details = SeriesDetail()
        if seriesDetail.id != id {
            fetchTVSeriesDetails(id: id)
        }
        details = self.seriesDetail
        return details
    }
    
    
}

// MARK: TV Series Watch Providers
extension MovieStore {
    
    /// Fetch all watch providers for series
    func fetchTVSeriesWatchProviders(id: Int) {
        // https://developers.themoviedb.org/3/tv/get-tv-watch-providers
        let seriesWatchProvidersRequest = "https://api.themoviedb.org/3/tv/\(id)/watch/providers?api_key=\(MovieStoreKey.apiKey.rawValue)"
        AF.request( seriesWatchProvidersRequest ).responseJSON { response in
            guard let data = response.data else { return }
                do {
                    let results = try self.decoder.decode(WatchProviders.self, from: data)
                    guard let resultsResponse = results.results else { return }
                    guard let usWatchProviders = resultsResponse.us else { return }
                    
                    self.watchProviders = usWatchProviders
                    let series = self.seriesStore.fetchSeries(uuid: id)
                    
                    self.seriesStore.update(series: series, providers: usWatchProviders)
                    
                } catch {
                    print(error)
                }
            
        }
    }
}



enum MovieStoreKey: String {
    case apiKey = "ebccbee67fef37cc7a99378c44af7d33" // API Key
    case imageURL = "https://image.tmdb.org/t/p/original" // used as base for movie images
}

// Used to extract actor credits depending on type
enum CreditExtractionType: String {
    case movie = "movie", tv = "tv"
}

 
