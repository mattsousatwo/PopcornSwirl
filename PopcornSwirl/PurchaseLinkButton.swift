//
//  PurchaseLinkButton.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/23/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct PurchaseLinkButton: View {
    
    var movieID: Int
    
    @State private var color: Color = .lightBlue
    
    @ObservedObject private var store = MovieStore()
    
    // Main Purchase Link
    private var links: PurchaseLink {
        return store.extractWatchProvidersFor(id: movieID)
    }
    
    // Purchase Link to Buy
    private var buy: [Provider]? {
        guard let buyProvider = links.buy else { return nil }
        print("BuyProvider.count: \(buyProvider.count)")
        return buyProvider
    }
    
    @State private var showActionSheet: Bool = false
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color)
            .frame(width: 200, height: 40, alignment: .center)
            .overlay(
                Text("Purchase"),
                alignment: .center )
            .onTapGesture {
                showActionSheet.toggle()
            }
            .actionSheet(isPresented: $showActionSheet) { () -> ActionSheet in
                ActionSheet(title: Text("Puchase"), message: nil, buttons: [
                    .default(Text("Button 1")) { self.color = .lightRed },
                    .cancel()
                        
                
                ])
            }

        
        
        
    }
    
    
    
    
    
    
}

struct PurchaseLinkButton_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseLinkButton(movieID: 0)
    }
}
