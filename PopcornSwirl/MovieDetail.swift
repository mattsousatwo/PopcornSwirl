//
//  MovieDetail.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MovieDetail: View {
    var body: some View {
       
 
        GeometryReader { geometry in
 
            ZStack {
                
                VStack {
                    
                    // Movie Poster
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height / 2)
                        .foregroundColor( Color.lightBlue).edgesIgnoringSafeArea(.top)
 
                    ZStack {
                            
                        // Detail Background
                        RoundedRectangle(cornerRadius: 20)
                            
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                            .shadow(radius: 2)
                            .foregroundColor(Color.pGray)
                            .edgesIgnoringSafeArea(.bottom)
                            .offset(x: 0,
                                    y: -25)
                        
                            
                        VStack {

                            HStack {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("rating")
                                    Text("Title")
                                    Text("Sub title ")
                                }
                                .padding()
                                Spacer()
                            }
                            
                            
                            Spacer()
                        }
                        
                        
                    } // z stack
                    .overlay(
                        
                            RoundedRectangle(cornerRadius: 8)
                            .frame(width: 60,
                                height: 60)
                            .foregroundColor( .darkBlue )
                            .shadow(radius: 8)
                            .padding()
                            .offset(x: -10,
                                    y: -65)
                            , alignment: .topTrailing)
                        
                    
                }  // v
                
            } // z
     
        } // geo
        
        
    } // body
} // Movie

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail()
    }
}
