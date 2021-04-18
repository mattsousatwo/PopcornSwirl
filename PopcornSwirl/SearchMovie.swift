//
//  SearchMovie.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/25/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SearchMovie: View {
    
    @State var searchTag: String
    @State var toggleSearch: Bool = false
    
    
    @ObservedObject var movieStore = MovieStore()
    
    var body: some View {

            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea(edges: .vertical)
                
                VStack {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                            .padding()
                        
                        TextField("Search", text: $searchTag).font(.title2)
                            .padding(.trailing)
                        
                        
                        Button(action: {
                            let movieQuery = searchTag.replacingOccurrences(of: " ", with: "+")
                            movieStore.fetchResultsForMovie(query: movieQuery)
                            
                            self.hideKeyboard()
                            
                        }) {
                            Text("Search")
                                .foregroundColor(.white)
                                .background( RoundedRectangle(cornerRadius: 12.0)
                                                .foregroundColor(.blue)
                                                .frame(width: 70,
                                                       height: 40)
                                                .shadow(radius: 3)
                                )
                                .padding()
                            
                        }
                        
                    }
                    .mask(
                        RoundedRectangle(cornerRadius: 10)
                            .background(Color.pGray)
                            .shadow(radius: 8))
                    
                    .frame(width: UIScreen.main.bounds.width,
                           height: 50)
                    
                    
                    let movieSearchResults = movieStore.extractMovieSearchResults()
                    CardRow(search: searchTag,
                            elements: movieSearchResults)
//                        .animation(.default)
                    
                    
                    
                    
                } // VStack
                
            } // ZStack
            
            .navigationBarTitle("Movie Search", displayMode: .inline)
        }

}

struct SearchMovie_Previews: PreviewProvider {
    static var previews: some View {
        SearchMovie(searchTag: "Jurrasic Park")
    }
}
