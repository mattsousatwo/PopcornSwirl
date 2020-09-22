//
//  ContentView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var showMenu = false
    
    
    var body: some View {
        
         
        
        NavigationView {
            ZStack {
                
                
                ScrollView(.vertical, showsIndicators:  false) {
                    VStack(spacing: 15) {
                        ForEach(1...8, id: \.self ) { i in
                            Text("Hello \(i)").font(.system(.title, design: .rounded)).bold()
                        }
                        
                    }.padding()
                    
                }// scroll
                    
                    
                GeometryReader { _ in
                    
                    HStack {
                        Menu().offset(x: self.showMenu ? 0 : -UIScreen.main.bounds.width )
                        
                        Spacer()
                    }
                    
                } .background(Color.black.opacity(self.showMenu ? 0.5 : 0)).edgesIgnoringSafeArea(.bottom)
                    .animation(.easeInOut)
                
                     
                        
                        
                    .navigationBarTitle("Home", displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: {
                            
                            self.showMenu.toggle()
                        }) {
                            if self.showMenu == true {
                                Image(systemName: "arrow.left").font(.body).foregroundColor(.black)
                            } else {
                                Image(systemName: "list.bullet").renderingMode(.original)
                            }
                        }
                    )
                
                
                
            } // Z
        } // Nav

        
    } // body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            
            Menu().previewLayout(.sizeThatFits)
            
        }
    }
}

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
