//
//  Menu.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct Menu: View {
    @State var movie = false
    @State var saved = false
    
    var body: some View {
        
        VStack(spacing: 25) {
            

            // Go to saved Movies
            NavigationLink(destination: MovieDetail(),
                           isActive: $movie,
                           label: { // Icon
                VStack {
                    Image(systemName: "doc.plaintext").resizable().scaledToFit()
                        .padding()
                        .frame(width: 70, height: 70)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                    Text("Detail").font(.title3).bold()
                        .foregroundColor(.black)
                    }
            })
            
            
            NavigationLink(destination: SavedMovies(),
                           isActive: $saved,
                           label: { // Icon
                VStack {
                    Image(systemName: "bookmark.fill").resizable().scaledToFit()
                        .padding()
                        .frame(width: 70, height: 70)
                        .background(Color.watermelonRed )
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                    Text("Saved").font(.title3).bold()
                        .foregroundColor(.black)
                    }
            })
            
            
            Button(action: {
                 
             }) {
                VStack {
                    // Icon
                    Image(systemName: "magnifyingglass").resizable().scaledToFit()
                        .padding()
                        .frame(width: 70, height: 70)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(12)
                    Text("Search").font(.title3).bold()
                        .foregroundColor(.black)
                }
             }
            
            
            
            WatchedButton()
            Spacer(minLength: 15)
            
        } // V stack
        .padding()
            .background(Color(.systemGray6)).edgesIgnoringSafeArea(.bottom)
        
    } // body
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu().previewLayout(.sizeThatFits)
    }
}
