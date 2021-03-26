//
//  Home.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI
import Alamofire


struct Home: View {
    
    @ObservedObject var movieStore = MovieStore()
    @ObservedObject var movieCD = MoviesStore()
    
    
    @State var presentModal: Bool = false
    
    var body: some View {
        
        // MARK: NAVLINK TEST -
//        NavigationView {
            
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.vertical)
                
                ScrollView(.vertical, showsIndicators: false ) {
                    
                    // MARK: Popular Movies Scroll
                    
                    VStack(spacing: 20) {
              
                        
                        ScrollBar(type: .popularMovie).equatable()
                        
                        
                        // MARK: Upcoming Movies scroll
                        
                        ScrollBar(type: .upcomingMovie).equatable()
                        
                        
                    } // VStack
                    // MARK: NAVLINK TEST -
                    .navigationBarTitle("Home", displayMode: .inline)
                    
                    
                    
                } // scroll
                .navigationBarBackButtonHidden(false)
            } // Z Stack
            // MARK: NAVLINK TEST -
//        } // Nav
        
    } // body
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
