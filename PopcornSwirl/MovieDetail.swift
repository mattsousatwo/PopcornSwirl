//
//  MovieDetail.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MovieDetail: View {
    
    @State private var showDesription: Bool = false
    
    
    var body: some View {
       
 
        GeometryReader { geometry in
            ScrollView {
                
                ZStack {
                        VStack(alignment: .leading) {
                            HStack(alignment: .bottom) {
                                // Movie Poster
                                MovieCard(color: .darkLime)
                                    .overlay(
                                        Image(systemName: "person.fill").resizable().scaledToFit().padding()
                                    )
                                    .padding()
                                VStack(alignment: .leading, spacing: 10) {
                                    // Movie Title
                                    Text("Title").font(.system(.largeTitle)).bold()
                                    // Genre
                                    Text("Action / Adventure")
                                    // Rating
                                    StarBar(value: 4.8)
                                        .padding(.vertical)
                                }
                            }
                            
                            // Description

                            Button(action: {
                                self.showDesription.toggle()
                            }) {
                                switch showDesription{
                                case true: // show
                                    
                                    Text("A really long description of the movie would go here. Probably 3 - 4 lines of text.")
                                case false: // hide
                                    Text("A short description of the movie...")
                                }
                            }
                            .foregroundColor(.black)
                            .animation(.default)
                            .padding()

                            
                            
                            // Actors scroll view
                            HStack {
                                Text("Actors").font(.system(.title2)).bold()
                                Spacer()
                                Text("See All")
                            }
                                .padding(.horizontal)
                                .padding(.top)
                            
                            ScrollView(.horizontal, showsIndicators:  false) {
                                HStack {
                                    ForEach(1...8, id: \.self ) { i in
                                    
                                        MovieCard(color: .pPurple).padding(.horizontal, 7)
                                    
                                    }
                                }
                            } // actors scroll view
                            
                            
                            RoundedRectangle(cornerRadius: 12)
                                .padding(.horizontal)
                                .frame(width: geometry.size.width, height: 100, alignment: .center)
                                .foregroundColor(.darkBlue)
                                .overlay(
                                    Text("Advertisment").font(.title)
                                        .foregroundColor(.pGray2)
                                    
                                )
                                
                            HStack {
                                Text("Suggested Movies").font(.system(.title2)).bold()
                                Spacer()
                                Text("See All")
                            }
                                .padding(.horizontal)
                                .padding(.top)
                            
                            ScrollView(.horizontal, showsIndicators:  false) {
                                HStack {
                                    ForEach(1...8, id: \.self ) { i in
                                    
                                        MovieCard(color: .lightPink).padding(.horizontal, 7)
                                    
                                    }
                                }
                            } // actors scroll view
                            
                            
                            
                        }
                        
                        
                            
                } // z stack
                    

                    .overlay(
                        
                            // Trailer button
                        HStack {
 
                            WatchedButton()
                            BookmarkButton()
                            
                            PlayButton(pressed: false)
                                
                            

                        }
                        .padding(.vertical)
                        .padding(.horizontal, 5)
//                            .offset(x: -10,
//                                    y: -145)
                            , alignment: .topTrailing)
                        
                
                
                
            } // scroll
            
            
        } // geo
        
        
        .background(Color.pGray)
        .edgesIgnoringSafeArea(.bottom)
        
        .navigationBarBackButtonHidden(false )
        
        
        
    } // body
} // Movie

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail()
    }
}
