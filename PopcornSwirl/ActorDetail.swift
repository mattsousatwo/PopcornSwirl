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
//    var biography: String
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
                        RemoteImage(url: image)
                            .clipShape( RoundedRectangle(cornerRadius: 12) )
                            .frame(width: geometry.size.width / 2,
                                   height: 250,
                                   alignment: .center)
                            .shadow(radius: 5.0)
                            .padding()
                            
                            .overlay(
                                imageGradient
                            )
                            .overlay(
                                Button(action: {
                                    print("Favorite Button Pressed ")
                                }, label: {
                                    Image(systemName: "heart").aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .padding()
                                        .foregroundColor(.lightBlue)
                                    
                                })
                                
                                , alignment: .bottomTrailing)
                            .padding()
                            
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
                        

                        if movies.count != 0 {
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text("Movies").font(.system(.title2)).bold()
                                    Spacer()
                                    if movies.count >= 10 {
                                        Button(action: {
                                            print("See All Movies")
                                        },
                                        label: {
                                            Text("See All").foregroundColor(.black)
                                        })
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top)
                                
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(0..<movies.count, id: \.self) { i in
                                            if i <= 9 {
                                                if let moviePosterPath = movies[i].poster_path,
                                                   let movieTitle = movies[i].title {
                                                    VStack {
                                                        RemotePoster(url: self.movie.imageURL + moviePosterPath)
                                                        Text(movieTitle).font(.system(.title3)).bold().lineLimit(nil)
                                                        Text(movies[i].character)
                                                    } // Vstack
                                                    .frame(width: 150)
                                                } // If Let
                                            } // If Index is less than
                                        } // ForEach
                                    } // HStack
                                    .padding()
                                } // Scroll
                                
                            } // VStack - Title + Scroll
                                .animation(.default)
                        } // if movies.count != 0
                        
                        
                        
                        
                        if tv.count != 0 {
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text("TV").font(.system(.title2)).bold()
                                    Spacer()
                                    if tv.count >= 10 {
                                        Button {
                                            print("See All TV Credits")
                                        } label: {
                                            Text("See All")
                                        }
                                    }

                                }
                                .padding(.horizontal)
                                .padding(.top)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack {
                                    
                                        ForEach(0..<tv.count, id: \.self) { i in
                                        
                                            if i <= 9 {
                                                VStack {
                                                    RemotePoster(url: self.movie.imageURL + (tv[i].poster_path ?? "" ))
                                                    Text(tv[i].name ?? "").font(.system(.title3)).bold()
                                                    Text(tv[i].character)
                                                }
                                                .frame(width: 150)
                                            }
                                        }
                                        
                                    } // HStack
                                        .padding()
                                } // Scroll
                            } // VStack - Title + Scroll
                            .animation(.default)
                        } // if tv.count != 0
                        
  
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
