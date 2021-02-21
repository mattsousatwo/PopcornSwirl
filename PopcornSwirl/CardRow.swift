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
    
    @Binding var search: String
    
    private var elementsArray: [[MovieSearchResults]] {
        if movieStore.movieSearchResults.isEmpty {
            movieStore.fetchResultsForMovie(query: search)
        }
//        let searchArray = movieStore.fetchResultsFromMovie(search: search)

        var newArray: [[MovieSearchResults]] = []

        let dividedCount = movieStore.movieSearchResults.count / 2

        if dividedCount >= 1 {
            newArray = movieStore.movieSearchResults.divided(into: 2)
        }
//        print("SearchArray: \(searchArray.count)")
        print("ElementsArray: \(newArray.count)")
        return newArray
    }

    
    
    // MARK: - swapped elements array with movie array - retrieving movie results after they are called and put them into an array - NOT WORKING
//    private var movieArray: [[MovieSearchResults]] {
//        let results = movieStore.extractMovieSearchResults()
//
//        var newArray: [[MovieSearchResults]] = []
//        let dividedCount = results.count / 2
//        if dividedCount >= 1 {
//            newArray = results.divided(into: 2)
//        }
//        print("Test 5 - results: \(results.count)")
//        return newArray
//    }
    
    
    private var showResults: Bool {
        
        switch elementsArray.count {
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
                        Text("Movie Count: (\(movieStore.movieSearchResults.count))")
                            .padding(.horizontal, 40)
                    }
                    
                    ScrollView {
                        VStack(alignment: .center) {
                            
                            ForEach(elementsArray, id: \.self) { array in
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

struct CardRow_Previews: PreviewProvider {
    static var previews: some View {
        CardRow(search: .constant("String")).previewLayout(.sizeThatFits)
    }
}
