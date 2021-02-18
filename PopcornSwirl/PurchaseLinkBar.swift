//
//  PurchaseLinkBar.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/22/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct PurchaseLinkBar: View {
    var movieID: Int
    var movie: Movie?
    @ObservedObject private var store = MovieStore()
    
    private var url: URL? {
        if let moviePurchaseLink = moivePurchaseLinks {
            guard let movieURL = moviePurchaseLink.url else { return nil }
            guard let url = URL(string: movieURL) else { return nil }
            return url
        } else if let fetchedLink = links {
            guard let movieURL = fetchedLink.url else { return nil }
            guard let url = URL(string: movieURL) else { return nil }
            return url
        }
        return nil
    }
    
    
    // MARK: - CoreData
    @ObservedObject private var movieCD = MoviesStore()
    
    private var moivePurchaseLinks: PurchaseLink? {
        if let movie = movie, let watchProviders = movie.watchProviders {
            guard let decodedWatchProviders = movieCD.decodeWatchProviders(watchProviders) else { return nil }
            return decodedWatchProviders
        }
        return nil
    }
    
    private var subscriptionLink: [Provider]? {
        if let link = moivePurchaseLinks {
            guard let flatrate = link.flatrate else { return nil }
            return flatrate
        }
        return nil
    }
    private var purchaseLink: [Provider]? {
        if let link = moivePurchaseLinks {
            guard let buy = link.buy else { return nil }
            return buy
        }
        return nil
    }
    private var rentLink: [Provider]? {
        if let link = moivePurchaseLinks {
            guard let rent = link.rent else { return nil }
            return rent
        }
        return nil
    }
    // MARK: -
    
    
    
    
    
    // MARK: - TMDB
    // Main Purchase Link
    private var links: PurchaseLink? {
        return store.extractWatchProvidersFor(id: movieID)
    }
    // Purchase Link with flatrate: Free?
    private var flatrate: [Provider]? {
        guard let links = links else { return nil }
        guard let rateProvider = links.flatrate else { return nil }
        print("Flatrate.count: \(rateProvider.count)")
        return rateProvider
    }
    // Purchase Link to Buy
    private var buy: [Provider]? {
        guard let links = links else { return nil }
        guard let buyProvider = links.buy else { return nil }
        print("BuyProvider.count: \(buyProvider.count)")
        return buyProvider
    }
    // Purchase Link to rent
    private var rent: [Provider]? {
        guard let links = links else { return nil }
        guard let rentProvider = links.rent else { return nil }
        return rentProvider
    }
    
    
    var body: some View {
        if let url = url {
            if let subscriptionLink = subscriptionLink {
                PurchaseLinkRow(type: .subscription, provider: subscriptionLink, link: url)
            } else if let flatrate = flatrate {
                PurchaseLinkRow(type: .subscription, provider: flatrate, link: url)
            }
            
            if let purchaseLink = purchaseLink {
                PurchaseLinkRow(type: .purchase, provider: purchaseLink, link: url)
            } else if let buy = buy {
                PurchaseLinkRow(type: .purchase, provider: buy, link: url)
            }
            
            if let rentLink = rentLink {
                PurchaseLinkRow(type: .rent, provider: rentLink, link: url)
            } else if let rent = rent {
                PurchaseLinkRow(type: .rent, provider: rent, link: url)
            }
        }

        
    }
}

struct PurchaseLinkBar_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseLinkBar(movieID: 0)
    }
}

enum PurchaseLinkType: String {
    case subscription = "Subscription"
    case purchase = "Purchase"
    case rent = "Rent"
}

struct PurchaseLinkRow: View {
    var type: PurchaseLinkType
    var provider: [Provider]
    var link: URL
    
    var body: some View {
        HStack {
            Text(type.rawValue).font(.system(.title, design: .rounded)).bold()
                .foregroundColor(.pGray3)
                .padding(.horizontal)
            Spacer()
        }
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(0..<provider.count, id: \.self) { i in
                    PurchaseLinkLabel(imageAdress: provider[i].logoPath, link: link)
                }
                
            }
            .padding(.horizontal)
        }
    }
}

// Label for Watch Providers
struct PurchaseLinkLabel: View {
    
    var radius: CGFloat = 10
    var opacity: Double = 0.6
    var color: Color = .lightBlue
    var width: CGFloat = 60
    var height: CGFloat = 60
    var shadow: CGFloat = 3
    
    var imageAdress: String?
    
    var link: URL
    
    
    private var url: URL? {
        guard let imageAdress = imageAdress else { return nil }
        guard let imageURL = URL(string: MovieStoreKey.imageURL.rawValue + imageAdress) else { return nil }
        return imageURL
    }
    
    var body: some View {
        if let url = url {
            Link(destination: link, label: {
            
                    AsyncImage(url: url, placeholder: {
                        RoundedRectangle(cornerRadius: radius)
                            .opacity(opacity)
                            .foregroundColor(color)
                            .frame(width: width, height: height)
                            .shadow(radius: shadow)
                    }, image: {
                        Image(uiImage: $0).resizable()
                    })
                    .clipShape( RoundedRectangle(cornerRadius: radius) )
                    .opacity(0.8)
                    .frame(width: width, height: height)
            })
        } else {
            RoundedRectangle(cornerRadius: radius)
                .opacity(opacity)
                .foregroundColor(color)
                .frame(width: width, height: height)
                .shadow(radius: shadow)
        }
        
    }
    
    
}
