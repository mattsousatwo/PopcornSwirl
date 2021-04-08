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
    func decodeActorCredits(_ credits: String, _ type: CreditExtractionType? = nil) -> [ActorCreditsCast]? {
        guard let data = credits.data(using: .utf8) else { return nil }
        guard let actorCredits = try? decoder.decode([ActorCreditsCast].self, from: data) else { return nil }
        
        var credits: [ActorCreditsCast] = []
        switch type {
        case nil:
            credits = actorCredits
        default:
            if let type = type {
                if actorCredits.count != 0 {
                    for credit in actorCredits {
                        if credit.media_type == type.rawValue {
                            credits.append(credit)
                        }
                    }
                }
            }
        }
    
        
        return credits
    }
    
    
    /// Convert PopMovie to String
    func encodePopularMovies(_ movies: [PopMovie]) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(movies) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Convert String to PopMovie
    func decodePopularMovies(_ movies: String) -> [PopMovie]? {
        guard let data = movies.data(using: .utf8) else { return nil }
        guard let popMovies = try? decoder.decode([PopMovie].self, from: data) else { return nil }
        return popMovies
    }
    
    /// Convert UpcommingMovie to String
    func encodeUpcomingMovies(_ movies: [UpcomingMovie]) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(movies) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Convert String to UpcomingMovie
    func decodeUpcomingMovies(_ movies: String) -> [UpcomingMovie]? {
        guard let data = movies.data(using: .utf8) else { return nil }
        guard let upcomingMovies = try? decoder.decode([UpcomingMovie].self, from: data) else { return nil }
        return upcomingMovies
    }
    
    
    // Convert TVSeriesCast to String
    func encodeTVSeriesCast(_ cast: [TVSeriesCast]) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(cast) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // Convert String to TVSeriesCast
    func decodeTVSeriesCast(_ cast: String) -> [TVSeriesCast]? {
        guard let data = cast.data(using: .utf8) else { return nil }
        guard let tvSeriesCast = try? decoder.decode([TVSeriesCast].self, from: data) else { return nil }
        return tvSeriesCast
    }
    
    // Convert Similar Series to String
    func encodeSimilarSeries(_ series: [SimilarSeries]) -> String? {
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(series) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // Convert String to Similar Series
    func decodeSimilarSeries(_ series: String) -> [SimilarSeries]? {
        guard let data = series.data(using: .utf8) else { return nil }
        guard let similarSeries = try? decoder.decode([SimilarSeries].self, from: data) else { return nil }
        return similarSeries
    }
    
    
}
