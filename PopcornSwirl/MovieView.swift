//
//  MovieView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MovieView: View {
    
    var movieID: Int
    var title: String
    var overview: String
    var rating: Double
    var genres: [Int]
    var posterURL: String
    
    @ObservedObject var movie = MovieStore() 
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(edges: .vertical)
                
                ScrollView(.vertical, showsIndicators: false) {

                    VStack(alignment: .center) {
                    // Poster
                        RemoteImage(url: movie.imageURL +  posterURL).clipShape( RoundedRectangle(cornerRadius: 6) )
                            .aspectRatio(contentMode: .fit)
                        .frame(height: geometry.size.height / 2)
                            .padding(.horizontal)
                            .padding(.top, 4)
                    
                        // MARK: Movie Title -
                        Text(title).bold().font(.title)
                        StarBar(value: rating)
                    
                        GenreBar(genres: genres).frame(alignment: .center)
                    
                        Text(overview).multilineTextAlignment(.center)
                            .frame(width: geometry.size.width - 30,
                                        alignment: .center)
                            .padding()
                        // MARK: -
                        
                        // MARK: Actors Scroll -
                        HStack {
                            Text("Cast").font(.system(.title2)).bold()
                            Spacer()
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {

                                if movie.actorImageProfiles.count != 0 {
                                    
                                    ForEach(0..<movie.actorImageProfiles.count, id: \.self) { index in
                                        if index <= 9 {
                                            
                                            if let actorImagePath = movie.actorImageProfiles[movie.movieCast[index].id] {
                                                
                                                RemoteActor(url: movie.imageURL + actorImagePath)
                                                
                                                
                                                
                                            } // actorImagePath
                                            
                                            
                                            
                                        } // actor limit
                                        
                                        
                                        
                                    } // For each
                                    
                                    
                                    
                                } // if actor images exist
                                
                                
                                
                            } .padding() // HStack
                            
                        } // Scroll
                        
                        // MARK: -
                        
                        
                        
                        
                        
                        
                    
                    
                    
                        Spacer()
                        
                        Button(action: {
                            print("Button Pressed ")
                        }, label: {
                            
                            Text("Buy Now")
                                .frame(width: geometry.size.width + 30 ,height: 40)
                                .background(Color.purpleBG)
                                
                            
                            
                        })
                        
                        
                } // vStack
                    
                    
                } // scroll
                
            } // zStack
            
        } // geo
        
        .onAppear() {
            movie.fetchMovieCreditsForMovie(id: movieID)
            movie.fetchRecommendedMoviesForMovie(id: movieID)
        }
        
        
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            MovieView(movieID: 12321,
                      title: "The Grinch",
                      overview: "A really long text file would go here. I was watching the grinch while I made this view. It was better than I remembered, and was pretty PC(probably because its a kids movie) which was surprising to me.",
                      rating: 8.8,
                      genres: [12, 16],
                      posterURL: "")
            
            GenreBar(genres: [12, 50]).previewLayout(.sizeThatFits)
        }
        
    }
}


struct GenreBar: View {
    
    private let movie = MovieStore()
    
    var genres: [Int]
    
    private var genreList: [String] {
        
        var genreNames: [String] = []
        
        genreNames = self.movie.extractGenres(from: genres)
        
        return genreNames
    }
    
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 30) {
            ForEach(genreList, id: \.self) { x in
            
            Text(x).bold()
                .foregroundColor(.pGray2)
                .background(RoundedRectangle(cornerRadius: 12)
                                .opacity(0.6)
                                .foregroundColor(.purpleBG)
                                .frame(width: 70,
                                       height: 40)
                                .shadow(radius: 3)
                )
            
            
            
            } .padding()
            
        }
    }
    
}


