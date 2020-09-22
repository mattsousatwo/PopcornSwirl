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
    
    var body: some View {
        
        VStack(spacing: 25) {
            

            NavigationLink(destination: MovieCard(),
                           isActive: $movie,
                           label: { // Icon
                Image(systemName: "person").resizable()
                    .padding()
                    .frame(width: 55, height: 55)
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(12)
            })
            
            
            Button(action: {
                 
             }) {
                 // Icon
                 Image(systemName: "person").resizable()
                     .padding()
                     .frame(width: 55, height: 55)
                     .background(Color.red)
                     .foregroundColor(Color.white)
                     .cornerRadius(12)
             }
            
            Button(action: {
                 
             }) {
                 // Icon
                 Image(systemName: "person").resizable()
                     .padding()
                     .frame(width: 55, height: 55)
                     .background(Color.blue)
                     .foregroundColor(Color.white)
                     .cornerRadius(12)
             }
            
            Spacer(minLength: 15)
            
        } // V stack
        .padding(35)
            .background(Color(.systemGray6)).edgesIgnoringSafeArea(.bottom)
        
    } // body
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu().previewLayout(.sizeThatFits)
    }
}
