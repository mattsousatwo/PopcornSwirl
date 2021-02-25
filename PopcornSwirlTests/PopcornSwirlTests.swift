//
//  PopcornSwirlTests.swift
//  PopcornSwirlTests
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import XCTest
@testable import PopcornSwirl 

class MovieTests: XCTestCase {
    
    private var movieCD = MoviesStore()
    private var movieStore = MovieStore()
    lazy var wonderWomanID = 464052 // Wonder Woman 1984
    lazy var galGadotID = 90633 // Gal Gadot
    
    lazy var movieTestID: Double = 999
    lazy var actorTestID = 888
    lazy var testTitle = "Test Title"
    
    // Test Movie Creation
    func testMovieCreation() {
        // Arrange
        let _ = movieCD.createNewMovie(uuid: movieTestID, title: testTitle)
        // Act
        let movieSearch = movieCD.fetchMovie(uuid: Int(movieTestID))
        // Assert
        XCTAssertTrue(movieSearch.title == testTitle, "Movie is not found - \(movieSearch)")
    }
    
    func testIfSavingMoviePropertiesWorks() {
        let movieSearch = movieCD.fetchMovie(uuid: Int(movieTestID))
        
        movieCD.update(movie: movieSearch, isWatched: true)
        
        print(movieSearch)
        XCTAssertEqual(movieSearch.isWatched, true)
    }
    
    func testFetchForFavoriteMovies() {
        print("FetchFavorites - TEST \n")
        let movies = movieCD.getAllFavoriteMovies()
        for movie in movies {
            print("Movie: \(movie.title ?? "NO TITLE"), isFav: \(movie.isFavorite)")
        }
        print("Movies: \(movies.count)")
        let favorites = movies.map({ $0.isFavorite == true })
        print("Favorites: \(favorites.count)")
        print("\n")
        XCTAssertEqual(movies.count, favorites.count)
    }
    
    
    func testForSavingMoviePropertiesFavoriteAndWatched() {
        let movieSearch = movieCD.fetchMovie(uuid: wonderWomanID)
        
        movieCD.update(movie: movieSearch, isWatched: true)
        
        print(movieSearch)
        XCTAssertEqual(movieSearch.isWatched, true)
    }
    
    
    // Test single Movie fetching
    func testIfFetchingSpecificMovieWorks() {
        
        let _ = movieCD.createNewMovie(uuid: movieTestID, director: "Matt Sousa", title: testTitle)
        
        let movie = movieCD.fetchMovie(uuid: Int(movieTestID))
        
        XCTAssertTrue(movie.uuid == Double(movieTestID), "Movie does not have matching ID")
    }
    
    // Search for movie using ID after all movies are fetched
    func testIfMovieIsThere() {
        movieCD.fetchMovies()
        let movie = movieCD.allMovies.first(where: { $0.uuid == Double(wonderWomanID) })
        print("movieCount: \(movieCD.allMovies.count)")
        XCTAssertNotNil(movie, "Movie is not found, movieCount: \(movieCD.allMovies.count)")
    }
    
    // test if fetching movies will work
    func testAllMovieFetching() {
        movieCD.fetchMovies()
        print("AllMovies: \(movieCD.allMovies.count)")
        XCTAssertFalse(movieCD.allMovies.count == 0, "No Movies are found")
    }
    
    // test if fetching by popular movie category is working
    func testPopularMovieFetching() {
        movieCD.fetchMovies(.popular)
        print("PopularMovie.count: \(movieCD.popularMovies.count)")
        XCTAssertFalse(movieCD.popularMovies.count == 0, "No Popular Movies Found")
    }
   
    // Test reccomended video fetching
    func testMovieBarForReccomended() {
        let reccomendedMovies = movieStore.movieForBar(.recommendedMovie, id: wonderWomanID)
        print("reccomendedMovies: \(reccomendedMovies.count)")
        XCTAssertFalse(reccomendedMovies.count == 0, "No Movies Found - count: \(reccomendedMovies.count)")
    }
    
    // Test if actors fetching is working
    func testMovieBarForActors() {
        let actors = movieStore.movieForBar(.actors, id: wonderWomanID)
        print("actors Count: \(actors.count)")
        XCTAssertFalse(actors.count == 0, "No Actors found - should update to use Actor not Movie")
    }
    
    // Test if actorsTV fetching is working
    func testMovieBarForActorTV() {
        let tv = movieStore.movieForBar(.actorTV, id: wonderWomanID)
        XCTAssertFalse(tv.count == 0, "No Actor TV Credits were found")
    }
    
    // Test if actorsMovie fetching is working
    func testMovieBarForActorMovie() {
        let tv = movieStore.movieForBar(.actorMovie, id: wonderWomanID)
        XCTAssertFalse(tv.count == 0, "No Actor Movie Credits were found")
    }
    
    // Test if delete movies is working
    func testDeleteAllMovies() {
        movieCD.deleteAllMovie()
        movieCD.fetchMovies()
        XCTAssertTrue(movieCD.allMovies.count == 0, "Movies were not deleted")
    }
    
    
    // Test scrollBar
    func testScrollBar() {
        let a = movieStore.extractRecomendedMovies(id: wonderWomanID)
        XCTAssertFalse(a.count == 0, "No actors found - \(a)")
    }
    
    
    // Test if encoding [Int] to JSON String & decode back to [Int] will work
    func testCodingAndDecodingGenres() {
        let genreIDs = [23, 42, 99, 103, 33, 4]
        var decodedValue: [Int] = []
        
        guard let IDsString = movieCD.encodeGenres(genreIDs) else { return }
        print("\n Coding&DecodingTest: Encoding - \(IDsString) \n")
        
        if let decodedString = movieCD.decodeGenres(IDsString) {
            decodedValue = decodedString
            print("\n Coding&DecodingTest: Decoding - \(decodedString) \n")
        }
        
        
        XCTAssertEqual(decodedValue, genreIDs, "\(decodedValue) is not equal to \(genreIDs)")
        
    }
    
    
     // MARK: - Figure out why ln: 164, 166 work here and not in .decodeGenres()
    func testDecodingGenres() {
        let genreIDs = [23,42,99,103,33,4]
        guard let IDsString = movieCD.encodeGenres(genreIDs) else { return }
        let idData = IDsString.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let ids = try! decoder.decode([Int].self, from: idData)
        
        print("\n - IDs: \(ids) \n")
        XCTAssertEqual(ids, genreIDs, "\(ids) is not equal to \(genreIDs)")
    }
    
    // Test if encoding & decoding works for cast
    func testCodingAndDecodingForCast() {
        
        let cast: [MovieCast] = [MovieCast(id: 1,
                                           known_for_department: "movie",
                                           name: "Actor 1",
                                           popularity: 5.0,
                                           profile_path: nil,
                                           character: "Character 1",
                                           order: 1),
                                 MovieCast(id: 2,
                                           known_for_department: "movie",
                                           name: "Actor 2",
                                           popularity: 10.0,
                                           profile_path: nil,
                                           character: "Character 2",
                                           order: 2)]
        
        var decodedCast: [MovieCast] = []
        
        
        guard let movieCastString = movieCD.encodeCast(cast) else { return }
        print( "\nMovieCast - \(movieCastString) \n")
        
        
        if let decodedData = movieCD.decodeCast(movieCastString) {
            decodedCast = decodedData
            print("    decodedData - PASSED\n")
            print(" - \(decodedData) \n")
        } else {
            print("    decodedData - FAILED\n")
        }
        
        
        
        XCTAssertEqual(decodedCast, cast, "\n decodedMovies - \(decodedCast), cast - \(cast) : Are not equal \n")
    }
    
    // Test if coding and decoding for RecommendedMovies works
    func testCodingForRecMovies() {
        
        var decodedMovies: [RecommendedMovie] = []
        let recMovies: [RecommendedMovie] = [RecommendedMovie(title: "Title 1",
                                                               poster_path: "PosterPath 1",
                                                               overview: "Overview for Movie",
                                                               popularity: 7.9,
                                                               id: 100,
                                                               vote_average: 2.0,
                                                               genre_ids: [1, 2],
                                                               release_date: "2019-12-16"),
                                            RecommendedMovie(title: "Title 2",
                                                             poster_path: "PosterPath 2",
                                                             overview: "Overview for Movie",
                                                             popularity: 12.3,
                                                             id: 200,
                                                             vote_average: 4.5,
                                                             genre_ids: [3, 5],
                                                             release_date: "2020-4-15")]
        guard let recMovieString = movieCD.encodeReccomendedMovies(recMovies) else { return }
        print("\nRecMovies: \(recMovieString)\n")
        
        if let decodedData = movieCD.decodeReccomendedMovies(recMovieString) {
            decodedMovies = decodedData
            print("\n movies: \(decodedMovies)")
        }
        XCTAssertEqual(recMovies, decodedMovies)
    }
    
    // Test if coding and decoding for Watch Providers works
    func testCodingForWatchProviders() {
        var decodedWatchProviders: PurchaseLink?
        let watchProviders: PurchaseLink = PurchaseLink(url: "URL",
                                                        buy: [Provider(displayPriority: 12,
                                                                       logoPath: "logoPath",
                                                                       providerID: 100,
                                                                       providerName: "Watch Provider")],
                                                        rent: [Provider(displayPriority: 10,
                                                                        logoPath: "Path",
                                                                        providerID: 122,
                                                                        providerName: "Provider Name")],
                                                        flatrate: [Provider(displayPriority: 1,
                                                                            logoPath: "Logo Path",
                                                                            providerID: 3,
                                                                            providerName: "Provider")])
        guard let purchaseLinkString = movieCD.encodeWatchProviders(watchProviders) else { return }
        print("\n PurchaseLinkString: \(purchaseLinkString) \n")
        if let decodedData = movieCD.decodeWatchProviders(purchaseLinkString) {
            decodedWatchProviders = decodedData
            print("\n decodedWatchProviders: \(decodedWatchProviders!) \n")
        }
        XCTAssertEqual(watchProviders, decodedWatchProviders)
    }
    
    
    // Testing if converting release date string to a readable format works
    func testReleaseDateFormating() {
        let dateString = "2020-02-17"
        let desiredFormat = "Feb 17, 2020"
        
        guard let date = dateString.convertToDate() else { return }
        let formater = DateFormatter()
        formater.dateFormat = "MMM d, yyyy"
        let formattedDate = formater.string(from: date)
        
        XCTAssertEqual(formattedDate, desiredFormat)
    }
    
    
}

class MovieStoreTests: XCTestCase {
    
    private var movieStore = MovieStore()
    lazy var wonderWomanID = 464052 // Wonder Woman 1984
    lazy var galGadotID = 90633 // Gal Gadot
    
    // test fetching movies
    func testReccomendedMovieFetching() {
        movieStore.fetchRecommendedMoviesForMovie(id: wonderWomanID)
        XCTAssertTrue(movieStore.recommendedMovies.count != 0, "No Movies Found - \(movieStore.recommendedMovies.count)")
    }
    
    func testActorFetching() {
        movieStore.fetchMovieCreditsForMovie(id: wonderWomanID)
        XCTAssertTrue(movieStore.movieCast.count != 0, "No Actors Found - \(movieStore.movieCast.count)")
    }
    
}

class ActorsTests: XCTestCase {
    
    private let actorsStore = ActorsStore()
    lazy var titoID = 90000
    lazy var titoName = "Tito Brophy"
    
    // Test if fetching actor works
    func testFetchingSpecificActor() {
        
        actorsStore.createActor(name: "Tito Brophy", bio: "Has dope hair", id: Double(titoID), imagePath: nil)
        let foundActor = actorsStore.fetchActorWith(id: titoID)
        
        XCTAssertEqual(foundActor.name, titoName, "Actor not found")
    }
    
    func testIfUpdateFuncWorks() {
        let actorID: Double = 200
        let name = "Matt"
        
        let actor = Actor(context: actorsStore.context)
        actor.id = actorID
        actorsStore.saveContext()
        actorsStore.update(actor: actor, name: name)
        XCTAssertEqual(actor.name, name, "Actor name is not equal to Matt - \(actor)")
    }
    
    func testIfCreditsEncodingWorks() {
        let actorsCredits = [ActorCreditsCast(id: 19,
                                 overview: "Overview",
                                 genre_ids: [12,13,14],
                                 name: "Name",
                                 media_type: "Movie",
                                 poster_path: "poster_path",
                                 vote_average: 4.9,
                                 character: "Character Name",
                                 title: "Credit Title",
                                 release_date: "12-02-18"),
                 ActorCreditsCast(id: 20,
                                  overview: "Overview",
                                  genre_ids: [15,16,17],
                                  name: "Credit Name",
                                  media_type: "TV",
                                  poster_path: "poster_path",
                                  vote_average: 8.0,
                                  character: "character name",
                                  title: "Credit title",
                                  release_date: "02-18-19")]
        
        
        guard let creditsString = actorsStore.encodeActorCredits(actorsCredits) else { return }
        
        guard let credits = actorsStore.decodeActorCredits(creditsString) else { return }
        
        XCTAssertEqual(actorsCredits, credits)
        
        
        
    }
    
}

class ArrayTests: XCTestCase {
    
    // Tests if extention to append an array if the array is under a certain count
    func testLimitedAppendExtention() {
        var testArray: [Int] = []
        for i in 0...30 {
            testArray.limited(append: i)
        }
        print("testArray.count \(testArray.count)")
        XCTAssertEqual(testArray.count, 25, ".limited(append: ) failed, array.count: \(testArray.count)")
    }
    
}

class SeriesTests: XCTestCase {
    

    
}

class FilmButtonTests: XCTestCase {
    
    var movieStore = MoviesStore()
    lazy var wonderWomanID = 464052 // Wonder Woman 1984
    
    func testIfFilmButtonSavingWorks() {
        
        let wonderWoman = movieStore.fetchMovie(uuid: wonderWomanID)
          
        
        
    }
    
}
