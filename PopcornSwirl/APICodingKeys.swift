//
//  APICodingKeys.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 11/20/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import Foundation
import Alamofire

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
    var genre_ids: [Int]
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
    public var vote_average: Double
    public var genre_ids: [Int]
    public var release_date: String
    public var backdrop_path: String
}


// MARK: - FINDBY

struct FindResults: Codable {
    
    var movie_results: [FindMovieResults]
    
    var person_results: [FindPersonResults]
    

}

struct FindMovieResults: Codable {
    var poster_path: String?
    var title: String
    var id: Int 
}

struct FindPersonResults: Codable {
    var profile_path: String?
    var adult: Bool
    var id: Int
    var name: String
    var popularity: Int
//    var known_for: [KnownFor]
    
}


// MARK: - Movie Credits
struct MovieCredits: Codable {
    var id: Int
    var cast: [MovieCast]
    var crew: [MovieCrew]
}

struct MovieCast: Codable {
    var id: Int
    var known_for_department: String
    var name: String
    var popularity: Double
    var profile_path: String?
    var character: String
    var order: Int
}

struct MovieCrew: Codable {
    var name: String
    var profile_path: String?
    var popularity: Double
    var department: String
    var job: String 
}



// MARK: Recommendations
struct Recommendation: Codable {
    var page: Int
    var results:  [RecommendedMovie]
}

struct RecommendedMovie: Codable { 
    var title: String
    var poster_path: String?
    var overview: String
    var popularity: Double
    var id: Int
    var vote_average: Double
}


// MARK: Search Results
struct MovieSearch: Codable {
    var page: Int?
    var results: [MovieSearchResults]?
}

struct MovieSearchResults: Codable, Hashable {
    var poster_path: String?
    var adult: Bool
    var overview: String
    var id: Int
    var title: String
    var backdrop_path: String?
    var popularity: Double
    var vote_average: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK: Upcoming Movies
struct UpcomingSchema: Codable {
    var page: Int
    var results: [UpcomingMovie]
    
}

struct UpcomingMovie: Codable {
    var poster_path: String?
    var overview: String
    var id: Int
    var title: String
    var backdrop_path: String?
    var popularity: Double
    var vote_average: Double
}


// MARK: - GET ACTOR IMAGES
struct ActorSchema: Codable {
    var id: Int
    var profiles: [ActorImageProfile]
}

struct ActorImageProfile: Codable {
    var file_path: String?
    var vote_average: Double
}


// MARK: - GENRES
struct Genres: Codable, Hashable {
    var id: Int
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct GenreArray: Codable {
    var genres: [Genres]

}
