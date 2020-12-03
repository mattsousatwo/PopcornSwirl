//
//  Home.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI
import Alamofire


struct Home: View {
    
    @State var showMenu = false
    
    @ObservedObject var movieStore = MovieStore() 
    
//    let movieStore = MovieStore()
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Latest").font(.system(.title, design: .rounded)).bold()
                            .padding(.horizontal)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators:  false) {
                        
                        HStack(spacing: 15) {
                                
                            ForEach(0..<movieStore.popularMovies.count, id: \.self ) { i in
                                VStack {
                                    
                                    
                                    if movieStore.popularMovies.count != 0 {
                                        NavigationLink(destination: MovieDetail()) {
                                        MovieCard()
                                        }
                                        
                                        Text("\(movieStore.popularMovies[i].title) \(i)").font(.system(.body, design: .rounded)).bold().lineLimit(2).multilineTextAlignment(TextAlignment.center)
                                         
                                    }
                                }
                            }
                                
                        } .padding()
                        
                    } // scroll

                    HStack {
                        Text("Popular").font(.system(.title, design: .rounded)).bold()
                            .padding(.horizontal)
                        Spacer()
                    }
                    // Horizontal Scroll
                    ScrollView(.horizontal, showsIndicators:  false) {
                        HStack(spacing: 15) {
                            ForEach(1...8, id: \.self ) { i in
                                VStack {
                                    MovieCard(color: Color(.systemTeal))
                                    Text("Movie \(i)").font(.system(.title, design: .rounded)).bold()
                                }
                            }
                            
                        }.padding()
                        
                    } // scroll

                } // VStack
                    
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
                                Image(systemName: "arrow.left").resizable().scaledToFit()
                                    .frame(width: 40, height: 20)
                                    .foregroundColor(.black)
                            } else {
                                Image(systemName: "list.bullet").resizable().scaledToFit()
                                    .frame(width: 40, height: 20)
                                    .foregroundColor(.black)
                            }
                        }
                    )
                
                } // Z
            
            .background(Color.snowWhite).edgesIgnoringSafeArea(.bottom)
        } // Nav
        
        
    } // body
}
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
