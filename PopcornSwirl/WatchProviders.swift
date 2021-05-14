//
//  WatchProviders.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 5/14/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation


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
struct PurchaseLink: Codable, Equatable {
    var url: String?
    var buy, rent: [Provider]?
    var flatrate: [Provider]?
    
    enum CodingKeys: String, CodingKey {
        case url = "link"
        case buy = "buy"
        case rent = "rent"
        case flatrate = "flatrate"
    }
    
    // Equatable
    static func ==(lhs: PurchaseLink, rhs: PurchaseLink) -> Bool {
        return lhs.url == rhs.url &&
            lhs.buy == rhs.buy &&
            lhs.rent == rhs.rent &&
            lhs.flatrate == rhs.flatrate
    }

}

// MARK: - Buy
struct Provider: Codable, Equatable {
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

    static func ==(lhs: Provider, rhs: Provider) -> Bool {
        return lhs.displayPriority == rhs.displayPriority &&
            lhs.logoPath == rhs.logoPath &&
            lhs.providerID == rhs.providerID &&
            lhs.providerName == rhs.providerName
    }
    
}

