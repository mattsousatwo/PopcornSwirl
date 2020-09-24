//
//  MovieDetail.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MovieDetail: View {
    var body: some View {
       
 
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                
                VStack {
                    
                    // Movie Poster
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height / 3)
                        .foregroundColor( Color.lightBlue).edgesIgnoringSafeArea(.top)
                    
                    ZStack {
                            
                        // Detail Background
                        RoundedRectangle(cornerRadius: 20)
                            
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                            .shadow(radius: 2)
                            .foregroundColor(Color.pGray)
                            .edgesIgnoringSafeArea(.bottom)

                            .overlay(
                                
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
                                            Text("Title")
                                            // Genre
                                            Text("Sub title ")
                                            // Rating
                                            StarBar(value: 2.7)
                                                .padding()
                                        }
                                    }
                                    
                                    // Description
                                    Text("Description")
                                        .padding()
                                        
                                    // Actors scroll view
                                    Text("Actors").font(.system(.largeTitle)).bold()
                                        .padding(.horizontal)
                                    
                                    ScrollView(.horizontal, showsIndicators:  false) {
                                        HStack {
                                            ForEach(1...8, id: \.self ) { i in
                                            
                                                MovieCard(color: .pPurple).padding()
                                            
                                            }
                                        }
                                    } // actors scroll view
                                    
                                    
                                    
                                    
                                }
                                , alignment: .topLeading )
                            
                       
                                
                        
                    } // z stack
                    
                    .offset(x: 0, y: -100)
                    .overlay(
                        
                            // Trailer button
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 50,
                                       height: 50)
                                .foregroundColor( .indigo)
                                .shadow(radius: 8)
                                .overlay(
                                    Image(systemName: "eye")
                                        .foregroundColor(.white)
                                )
                                .padding()
                            
                            
                                
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 50,
                                       height: 50)
                                .foregroundColor( .indigo)
                                .shadow(radius: 8)
                                .overlay(
                                    Image(systemName: "bookmark")
                                        .foregroundColor(.white)
                                )
                                .padding()
                            
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 50,
                                       height: 50)
                                .foregroundColor( .indigo)
                                .shadow(radius: 8)
                                .overlay(
                                    Image(systemName: "play.fill")
                                        .foregroundColor(.white)
                                )
                                .padding()
                        }
                            .offset(x: -10,
                                    y: -145)
                            , alignment: .topTrailing)
                        
                
                }  // v
                
            } // z
            }
        } // geo
        
        .navigationBarBackButtonHidden(false )
        
        
        
    } // body
} // Movie

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail()
    }
}
