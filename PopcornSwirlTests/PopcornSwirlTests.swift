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



class CastTests: XCTestCase {
    
    private let castStore = CastStore()
    
    func fetchAllCastMembersTest() throws {
        // Arrange
        castStore.fetchAllCastEntities()
        
        // Act
        
        
        // Assert
        
        
        
    }
    
    
    
    
}
