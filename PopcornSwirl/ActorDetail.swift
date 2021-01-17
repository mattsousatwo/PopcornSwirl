//
//  ActorDetail.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/26/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ActorDetail: View {
    
    var image: String
    var actorID: Int
    var name: String
    @State var isFavorite: Bool
    
    @State private var showFullBio: Bool = false
    
    @ObservedObject private var movie = MovieStore()
    
    private var movies: [ActorCreditsCast] {
        var moviesArray: [ActorCreditsCast] = []
        if movie.actorCredits.count != 0 {
            for movie in movie.actorCredits {
                if movie.media_type == "movie" {
                    moviesArray.append(movie)
                }
            }
        }
        print("MoviesArray.count : \(moviesArray.count)")
        return moviesArray
    }
    
    private var tv: [ActorCreditsCast] {
        var tvArray: [ActorCreditsCast] = []
        if movie.actorCredits.count != 0 {
            for series in movie.actorCredits {
                if series.media_type == "tv" {
                    tvArray.append(series)
                }
            }
        }
        return tvArray
    }
    
    
    private var details: ActorDetails? {
        if movie.actorDetails.count != 0 {
            return movie.actorDetails.first
        }
        return nil
    }
    
    private var imageGradient: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [Color.clear, Color.blue.opacity(0.2)]),
                              startPoint: .top,
                              endPoint: .bottom)
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea(edges: .vertical)
                
                // Content
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        
                        HStack(alignment: .center) {
                            
                            Spacer()
                            
                            LargeActorCard(url: URL(string: image), rating: nil )
                            
                            Spacer()

                        }
                        
                        Text(name).font(.title).bold().foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                        
                        
                        VStack(alignment: .leading ) {
                            ForEach(movie.actorDetails, id: \.self) { details in
                                Text("Birth Place:").font(.title2).bold()
                                if details.deathday == "" {
                                    Text("\(details.birthday ?? "" ) - \(details.deathday ?? "" )")
                                } else {
                                    Text( "\(details.birthday ?? "") (\((details.place_of_birth ?? ""))) " )
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                        
                        Text("Biography").font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        if let details = details {
                            Button(action: {
                                self.showFullBio.toggle()
                            }, label: {
                                Text(details.biography).lineLimit(showFullBio ? nil : 6 )
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            })
                        }
                        
                        // MARK: Movies
                        ScrollBar(type: .actorMovie, id: actorID)
                        
                        // MARK: TVSeries 
                        ScrollBar(type: .actorTV, id: actorID)
                        
                    } // VStack
                    
                } // Scroll View
            } // ZStack
        } // GeometryReader
        
        .onAppear(perform: {
            movie.fetchCreditsFor(actor: actorID)
            movie.fetchDetailsForActor(id: actorID)
        })
        
    } // body
    
    
    
} // ActorDetail

struct ActorDetail_Previews: PreviewProvider {
    static var previews: some View {
        ActorDetail(image: "ImagePath",
                    actorID: 1,
                    name: "Actor Name",
                    isFavorite: true )
    }
}
