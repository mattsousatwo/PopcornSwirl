//
//  CoreDataCoder.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/24/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation

class CoreDataCoder {
    
    lazy var decoder = JSONDecoder()
    lazy var encoder = JSONEncoder()
    
    /// Convert MovieCast to String
    func encodeCast(_ cast: [MovieCast]) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(cast) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Convert String to MovieCast
    func decodeCast(_ movieCast: String) -> [MovieCast]? {
        guard let data = movieCast.data(using: .utf8) else { return nil }
        guard let cast = try? decoder.decode([MovieCast].self, from: data) else { return nil }
        return cast
        
    }
    
    /// Encode Array of Genre ID tags to JSON Data as String for saving
    /// Example: FetchGenreIDs -> encode(genres: ) ->  update(movie:, genres: )
    func encodeGenres(_ genres: [Int]) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(genres) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Convert String to Genre IDs
    func decodeGenres(_ string: String) -> [Int]? {
        guard let data = string.data(using: .utf8) else { return nil }
        guard let ids = try? decoder.decode([Int].self, from: data) else { return nil }
        return ids
        
    }
    
    /// Convert Watch Providers to String
    func encodeWatchProviders(_ provider: PurchaseLink) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(provider) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Convert String to PurchaseLink
    func decodeWatchProviders(_ provider: String) -> PurchaseLink? {
        guard let data = provider.data(using: .utf8) else { return nil }
        guard let providers = try? decoder.decode(PurchaseLink.self, from: data) else { return nil }
        return providers
    }
    
    /// Convert ReccomendedMovie to String
    func encodeReccomendedMovies(_ movies: [RecommendedMovie]) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(movies) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Convert String to ReccomendedMovies
    func decodeReccomendedMovies(_ movies: String) -> [RecommendedMovie]? {
        guard let data = movies.data(using: .utf8) else { return nil }
        guard let recMovies = try? decoder.decode([RecommendedMovie].self, from: data) else { return nil }
        return recMovies
    }
    
    /// Convert ActorCredits to String
    func encodeActorCredits(_ credits: [ActorCreditsCast]) -> String? {
        guard let data = try? encoder.encode(credits) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Decode String to ActorCredits
    func decodeActorCredits(_ credits: String) -> [ActorCreditsCast]? {
        guard let data = credits.data(using: .utf8) else { return nil }
        guard let actorCredits = try? decoder.decode([ActorCreditsCast].self, from: data) else { return nil }
        return actorCredits
    }
    
}
