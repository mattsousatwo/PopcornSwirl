//
//  CardRow.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/12/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct CardRow: View {
    
    @ObservedObject var movieStore = MovieStore()
    @ObservedObject var movieCD = MoviesStore()
    
    var search: String
    
    
    var elements: [[MovieSearchResults]]
        
    private var showResults: Bool {
        
        switch elements.count {
        case 0:
            return false
        default:
            return true
        }
    }

    var body: some View {
        
        GeometryReader { geometry in
            
            
            
            if showResults == true {
                VStack {
                    HStack {
                        Spacer()
                        Text("Movie Count: (\(elements.count))")
                            .padding(.horizontal, 40)
                    }
                    
                    ScrollView {
                        VStack(alignment: .center) {
                            
//                            ForEach(elementsArray, id: \.self) { array in
                            ForEach(elements, id: \.self) { array in
                                HStack {
                                    //                            Spacer()
                                    ForEach(array, id: \.self) { movie in
                                        
                                        NavigationLink(destination: MovieDetail(movieID: movie.id,
                                                                                movieTitle: movie.title,
                                                                                genreIDs: movie.genre_ids,
                                                                                movieOverview: movie.overview,
                                                                                posterPath: (movie.poster_path ?? ""),
                                                                                rating: movie.vote_average,
                                                                                releaseDate: "").equatable() ,
                                                       label: {
                                                        let movieElement = movieCD.fetchMovie(uuid: movie.id)
                                                        ImageCard(url: URL(string: MovieStoreKey.imageURL.rawValue + (movie.poster_path ?? "")), movie: movieElement)  })
                                        
                                    } // ForEach(array)
                                    .padding(.horizontal)
                                    Spacer()
                                } // HStack
                                .frame(width: geometry.size.width,
                                       height: 200,
                                       alignment: .center)
                                .padding()
                            } // ForEach(elementsArray)
                            .padding()
                            
                        } // VStack
                    } // Scroll
                    
                    .animation(.default)
                }
                
            } else { // show results
                VStack {
                    HStack {
                        Spacer()
                        Text("No Results Found").padding()
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            
        } // Geo
        
    }
        
}


//
//struct CardRow_Previews: PreviewProvider {
//    static var previews: some View {
//        CardRow(search: .constant("String")).previewLayout(.sizeThatFits)
//    }
//}
