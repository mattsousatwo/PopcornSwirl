//
//  PopcornSwirlTests.swift
//  PopcornSwirlTests
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import XCTest
@testable import PopcornSwirl

class RatingTests: XCTestCase {
    
    private var ratingStore = MovieRatingStore()
    
    func testIfDoublesAreBeingCreatedFromFetchingAll() throws {
        
        ratingStore.fetchAllRatings()
        
    }
    
    // See if creating a new rating will cause doubles to be created
    func testIfSearchingForARatingWillCauseDoubles() throws {
        
        // Arrange
        ratingStore.fetchAllRatings()
        let ratingsCount = ratingStore.ratings.count
        
        // Act
        let rating = ratingStore.searchForRatingsFromMovie(id: 1) 
        print(rating)
        
        // Assert
        XCTAssertEqual(ratingStore.ratings.count, ratingsCount)
    }
    
    func testPreformance() throws {
        self.measure {
            
        }
    }
    
    
    
}

class MovieTests: XCTestCase {
    
    private var movieCD = MoviesStore()
    private var movieStore = MovieStore()
    lazy var wonderWomanID = 464052 // Wonder Woman 1984
    lazy var galGadotID = 90633 // Gal Gadot
    
    lazy var movieTestID: Double = 999
    lazy var actorTestID = 888
    lazy var testTitle = "Test Title"
    
    
    // Test if we can decode json to string for saving
    func testIfdecodingToStringisWorking() {
        let popularMovieString = movieStore.decodePopularMoviesAsString()
        XCTAssertEqual(popularMovieString, "", "Popular Movie string is empty - \(popularMovieString)")
    }
    
    
    // Test Movie Creation
    func testMovieCreation() {
        // Arrange
        let _ = movieCD.createNewMovie(uuid: movieTestID, title: testTitle)
        // Act
        let movieSearch = movieCD.fetchMovie(uuid: Int(movieTestID))
        // Assert
        XCTAssertTrue(movieSearch.title == testTitle, "Movie is not found - \(movieSearch)")
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
        movieCD.fetchMovies(in: .popular)
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


class CastTests: XCTestCase {
    
    private let castStore = CastStore()
    
    func testfetchAllCastMembers() throws {
        // Arrange
        castStore.fetchAllCastEntities()
        
        // Act
        
        
        // Assert
        
        
        
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
