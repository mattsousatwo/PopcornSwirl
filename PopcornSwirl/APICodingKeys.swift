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
 

class PopMovie: Codable, Identifiable {
    public var id: Int
    public var title: String
    public var overview: String
    public var poster_path: String
    public var vote_average: Double
    public var genre_ids: [Int]
    public var release_date: String
    public var backdrop_path: String?
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
    var vote_average: Double
    var genre_ids: [Int]
    var overview: String 
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
    var page: Int?
    var results:  [RecommendedMovie]?
}

struct RecommendedMovie: Codable { 
    var title: String
    var poster_path: String?
    var overview: String
    var popularity: Double
    var id: Int?
    var vote_average: Double
    var genre_ids: [Int]
    var release_date: String?
    
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
    var genre_ids: [Int]
    
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
    var genre_ids: [Int]
    var release_date: String
}


// MARK: - GET ACTOR IMAGES
struct ActorSchema: Codable {
    var id: Int?
    var profiles: [ActorImageProfile]
}

struct ActorImageProfile: Codable {
    var file_path: String?
    var vote_average: Double
}

// MARK: - ACTOR CREDITS
struct ActorCredits: Codable {
    var cast: [ActorCreditsCast]
    var id: Int?
}

struct ActorCreditsCast: Codable, Hashable {
    var id: Int?
    var overview: String
    var genre_ids: [Int]
    var name: String?
    var media_type: String
    var poster_path: String?
    var vote_average: Double
    var character: String
    var title: String?
    var release_date: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK: -



// MARK: - ACTOR DETAILS
struct ActorDetails: Codable, Hashable {
    var birthday: String?
    var known_for_department: String
    var deathday: String?
    var id: Int
    var name: String
    var also_known_as: [String]
    var gender: Int
    var biography: String
    var popularity: Double
    var place_of_birth: String?
    var profile_path: String?
    var imdb_id: String
    var homepage: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK: -


// MARK: - GENRES
struct Genre: Codable, Hashable {
    var id: Int
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct GenreArray: Codable {
    var genres: [Genre]

}


// MARK: - WatchProviders
struct WatchProviders: Codable {
    var id: Int
    var results: Results?
}

// MARK: - Results
struct Results: Codable {
    var ar, at, au, be, br, ca, ch, cl, co, cz,
        de, dk, ec, ee, es, fi, fr, gb, gr, hu,
        id, ie, iN, it, jp, kr, lt, lv, mx, my,
        nl, no, nz, pe, ph, pl, pt, ro, ru, se,
        sg, th, tr, us, ve, za: PurchaseLink?

    enum CodingKeys: String, CodingKey {
        case ar = "AR"
        case at = "AT"
        case au = "AU"
        case be = "BE"
        case br = "BR"
        case ca = "CA"
        case ch = "CH"
        case cl = "CL"
        case co = "CO"
        case cz = "CZ"
        case de = "DE"
        case dk = "DK"
        case ec = "EC"
        case ee = "EE"
        case es = "ES"
        case fi = "FI"
        case fr = "FR"
        case gb = "GB"
        case gr = "GR"
        case hu = "HU"
        case id = "ID"
        case ie = "IE"
        case iN = "IN"
        case it = "IT"
        case jp = "JP"
        case kr = "KR"
        case lt = "LT"
        case lv = "LV"
        case mx = "MX"
        case my = "MY"
        case nl = "NL"
        case no = "NO"
        case nz = "NZ"
        case pe = "PE"
        case ph = "PH"
        case pl = "PL"
        case pt = "PT"
        case ro = "RO"
        case ru = "RU"
        case se = "SE"
        case sg = "SG"
        case th = "TH"
        case tr = "TR"
        case us = "US"
        case ve = "VE"
        case za = "ZA"
    }
}

// MARK: - Au
struct PurchaseLink: Codable {
    var url: String?
    var buy, rent: [Provider]?
    var flatrate: [Provider]?
    
    enum CodingKeys: String, CodingKey {
        case url = "link"
        case buy = "buy"
        case rent = "rent"
        case flatrate = "flatrate"
    }
    
}

// MARK: - Buy
struct Provider: Codable {
    var displayPriority: Int
    var logoPath: String
    var providerID: Int
    var providerName: String

    enum CodingKeys: String, CodingKey {
        case displayPriority = "display_priority"
        case logoPath = "logo_path"
        case providerID = "provider_id"
        case providerName = "provider_name"
    }
}
