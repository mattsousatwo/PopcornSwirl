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
    var actor: Actor?
    @State var isFavorite: Bool
    @ObservedObject private var actorStore = ActorsStore()
    
    @State private var showFullBio: Bool = false
    
    @ObservedObject private var movie = MovieStore()
    
    private var details: ActorDetails? {
        if movie.actorDetails.count != 0 {
            return movie.actorDetails.first
        }
        return nil
    }
    
    private func displayBirthday() -> some View {
        var birthdate: String?
        var birthPlace: String?
        var deathDate: String?
        
        // coredata
        if let actor = actor {
            if let actorBirthdate = actor.birthDate {
                birthdate = actorBirthdate
            }
            if let actorBirthPlace = actor.birthPlace {
                birthPlace = actorBirthPlace
            }
            if let actorDeath = actor.deathDate {
                deathDate = actorDeath
            }
        }
        
        // TMDB
        if birthdate == nil {
            for movie in movie.actorDetails {
                if let birthDate = movie.birthday {
                    birthdate = birthDate
                }
            }
        }
        if birthPlace == nil {
            for movie in movie.actorDetails {
                if let placeOfBirth = movie.place_of_birth {
                    birthPlace = placeOfBirth
                }
            }
        }
        if deathDate == nil {
            for movie in movie.actorDetails {
                if let deathday = movie.deathday {
                    deathDate = deathday
                }
            }
        }
        
        
        let stack = VStack(alignment: .leading) {
            Text("Birth:").font(.title2).bold()
            if let deathdate = deathDate {
                if let birthdate = birthdate {
                    if let birthplace = birthPlace {
                        Text("\(birthdate)(\(birthplace)) - \(deathdate)")
                    }
                }
            } else if let birthdate = birthdate {
                if let birthplace = birthPlace {
                    Text("\(birthdate), \(birthplace)")
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .foregroundColor(.white)
        
        
        return stack
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
                            
                            LargeImageCard(url: URL(string: image), actor: actor)
                                .padding()
                            
                            Spacer()
                            
                        }
                        
                        Text(name).font(.title).bold().foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                        
                        
                        // Birthdate
                        displayBirthday()
                        
//                        VStack(alignment: .leading ) {
//                            ForEach(movie.actorDetails, id: \.self) { details in
//                                Text("Birth Place:").font(.title2).bold()
//                                if details.deathday == "" {
//                                    Text("\(details.birthday ?? "" ) - \(details.deathday ?? "" )")
//                                } else {
//                                    Text( "\(details.birthday ?? "") (\((details.place_of_birth ?? ""))) " )
//                                }
//                            }
//
//                        }
//                        .padding(.horizontal)
//                        .padding(.bottom, 5)
//                        .foregroundColor(.white)
//
                        
                        
                        
                        
                        Text("Biography").font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        if let actor = actor {
                            Button(action: {
                                self.showFullBio.toggle()
                            }, label: {
                                Text(actor.biography ?? "").lineLimit(showFullBio ? nil : 6 )
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
