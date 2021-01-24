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
    @ObservedObject private var store = MovieStore()
    
    // Main Purchase Link
    private var links: PurchaseLink {
        return store.extractWatchProvidersFor(id: movieID)
    }
    // Purchase Link with flatrate: Free?
    private var flatrate: [Provider]? {
        guard let rateProvider = links.flatrate else { return nil }
        print("Flatrate.count: \(rateProvider.count)")
        return rateProvider
    }
    // Purchase Link to Buy
    private var buy: [Provider]? {
        guard let buyProvider = links.buy else { return nil }
        print("BuyProvider.count: \(buyProvider.count)")
        return buyProvider
    }
    // Purchase Link to rent
    private var rent: [Provider]? {
        guard let rentProvider = links.rent else { return nil }
        return rentProvider
    }
    
    
    var body: some View {
        
        
        HStack {
            Text("Flatrate").font(.system(.title, design: .rounded)).bold()
                .foregroundColor(.pGray3)
                .padding()
            
            Spacer()
        }
        
        if let flatrate = flatrate {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<flatrate.count, id: \.self) { i in
                        PurchaseLinkLabel(imageAdress: flatrate[i].logoPath)
                    }
                }
                .padding()
            }
        }
        
        
        
        
        HStack {
            Text("Buy").font(.system(.title, design: .rounded)).bold()
                .foregroundColor(.pGray3)
                .padding()
            
            Spacer()
        }
        
        if let buy = buy {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<buy.count, id: \.self) { i in
                        PurchaseLinkLabel(imageAdress: buy[i].logoPath)
                        
                    }
                }
                .padding()
            }
            
        }
        
        
        
        
        HStack {
            Text("Rent").font(.system(.title, design: .rounded)).bold()
                .foregroundColor(.pGray3)
                .padding()
            
            Spacer()
        }
        
        if let rent = rent {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<rent.count, id: \.self) { i in
                        PurchaseLinkLabel(imageAdress: rent[i].logoPath)
                    }
                    
                }
                .padding()
            }
        }
        
        
        

        
    }
}

struct PurchaseLinkBar_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseLinkBar(movieID: 0)
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
    
    
    private var url: URL? {
        guard let imageAdress = imageAdress else { return nil }
        guard let imageURL = URL(string: MovieStoreKey.imageURL.rawValue + imageAdress) else { return nil }
        return imageURL
    }
    
    
    
    var body: some View {
        
        if let url = url {
            RoundedRectangle(cornerRadius: radius)
                .opacity(opacity)
                .foregroundColor(color)
                .frame(width: width, height: height)
                .shadow(radius: shadow)
                .overlay(
                    AsyncImage(url: url, placeholder: {
                        RoundedRectangle(cornerRadius: radius)
                    }, image: {
                        Image(uiImage: $0).resizable()
                    })
                    .clipShape( RoundedRectangle(cornerRadius: radius) )
                    .opacity(0.8)
                    .frame(width: (width / 2) + (width / 3),
                           height: (height / 2) + (height / 3))

                    , alignment: .center)
                
    
        } else {
            RoundedRectangle(cornerRadius: radius)
                .opacity(opacity)
                .foregroundColor(color)
                .frame(width: width, height: height)
                .shadow(radius: shadow)
        }
        
    }
    
    
}
