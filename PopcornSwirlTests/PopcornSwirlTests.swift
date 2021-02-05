//
//  PopcornSwirlTests.swift
//  PopcornSwirlTests
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import XCTest
@testable import PopcornSwirl

class PopcornSwirlTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

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
    lazy var movieID = 464052 // Wonder Woman 1984
    lazy var actorID = 90633 // Gal Gadot
    
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
        let reccomendedMovies = movieStore.movieForBar(.recommendedMovie, id: movieID)
        print("reccomendedMovies: \(reccomendedMovies.count)")
        XCTAssertFalse(reccomendedMovies.count == 0, "No Movies Found")
    }
    
    // Test if actors fetching is working
    func testMovieBarForActors() {
        let actors = movieStore.movieForBar(.actors, id: movieID)
        print("actors Count: \(actors.count)")
        XCTAssertFalse(actors.count == 0, "No Actors found - should update to use Actor not Movie")
    }
    
    // Test if actorsTV fetching is working
    func testMovieBarForActorTV() {
        let tv = movieStore.movieForBar(.actorTV, id: movieID)
        XCTAssertFalse(tv.count == 0, "No Actor TV Credits were found")
    }
    
    // Test if actorsMovie fetching is working
    func testMovieBarForActorMovie() {
        let tv = movieStore.movieForBar(.actorMovie, id: movieID)
        XCTAssertFalse(tv.count == 0, "No Actor Movie Credits were found")
    }
    
    // Test if delete movies is working
    func testDeleteAllMovies() {
        movieCD.deleteAllMovie()
        movieCD.fetchMovies()
        XCTAssertTrue(movieCD.allMovies.count == 0, "Movies were not deleted")
    }
}



class CastTests: XCTestCase {
    
    private let castStore = CastStore()
    
    func fetchAllCastMembersTest() throws {
        // Arrange
        castStore.fetchAllCastEntities()
        
        // Act
        
        
        // Assert
        
        
        
    }
    
    
    
    
}
