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
    
    @ObservedObject var movieStore = MovieStore()
    
    var movieID = Int()
    var movieTitle = String()
//    var genre = String()
    var movieOverview = String()
    
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
                                    Text(movieTitle).font(.system(.largeTitle)).bold()
                                    // Genre
                                    Text("Action / Adventure").foregroundColor(.gray)
                                    // Rating
                                    StarBar(value: 4.8)
                                        .padding(.vertical, 4)
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
                                    Text(movieOverview)
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
                                    
                                        ActorCard2(color: .coral,
                                                  image: Image(systemName: "person.fill"),
                                                  width: 100,
                                                  height: 200)
                                            .padding(.horizontal, 7).padding(.vertical, 5)
                                    
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
        
        
        .onAppear() {
            print( "Movie ID: \(movieID)"  )
            print( "Movie Title: \(movieTitle)"  )
            print( "Movie Overview: \(movieOverview)"  )
            
            movieStore.fetchExternalIDWithMovie(id: movieID)
            movieStore.fetchActorsForMovie(id: movieStore.externalMovieID)
        }
        
        
    } // body
} // Movie

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail()
    }
}
