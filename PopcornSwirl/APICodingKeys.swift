//
//  APICodingKeys.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 11/20/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Latest Movies Coding Keys
struct Latest: Codable {
    var page: Int
    var results: [LatestMovie]
}


struct LatestMovie: Codable {
    var poster_path: String
    var adult: Bool
    var overview: String
    var release_date: String
//    var genre_ids: [GenreIDs]
    var id: Int
    var original_title: String
    var original_language: String
    var title: String
    var backdrop_path: String
    var popularity: Double
    var vote_count: Double 
    var video: Bool
    var vote_average: Double
}


// MARK: - Popular Coding Keys
struct Popular: Codable {
    public var page: Int
    public var results: [PopMovie]
}

struct PopularMovie: Codable {
    var poster_path: String
    var adult: Bool
    var overview: String
    var release_date: String
    var id: Int
//    var genre_ids
    var original_title: String
    var original_language: String
    var title: String
    var backdrop_path: String
    var popularity: Double
    var vote_count: Int
    var video: Bool
    var vote_average: Double
}




struct PopMovie: Codable, Identifiable {
    public var id: Int
    public var title: String
    public var overview: String
    public var poster_path: String 
}



    
// MARK: - LatestMovies
struct Latest2: Codable {
    var title: String
    var release_date: String
    var vote_average: Int
    var vote_count: Int
    var poster_path: String?
}




// External IDs - used to get data from IMDB
struct ExternalID: Codable {
    var imdb_id: String?
    var id: Int 
}



// MARK: - FINDBY

struct FindResults: Codable {
    
    var movie_results: [FindMovieResults]
    
    var person_results: [FindPersonResults]
    

}

struct FindMovieResults: Codable {
    var poster_path: String?
}

struct FindPersonResults: Codable {
    var profile_path: String?
    var adult: Bool
    var id: Int
    var name: String
    var popularity: Int
//    var known_for: [KnownFor]
    
}
