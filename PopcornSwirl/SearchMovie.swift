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
                            
                            print(" ~ Search Button Pressed ~")
                            movieStore.fetchResultsForMovie(query: searchTag)
                            
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
                    
            
            // MARK: animation doesnt solve search looping issue && Bool doesnt work to show results 
            
                SavedRow(search: $searchTag)
                    .animation(.default)
            
                
            
            
        } // VStack
//        .background(Color.pGray)
    } // ZStack
//        .edgesIgnoringSafeArea(.top)
        
    }
}

struct SearchMovie_Previews: PreviewProvider {
    static var previews: some View {
        SearchMovie(searchTag: "Jurrasic Park")
    }
}
