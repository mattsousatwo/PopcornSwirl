//
//  StarSlider.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 1/16/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import Foundation
import SwiftUI

struct StarSlider: View {
    
    var movie: Movie
    
    @State var value: Double = 0 // Change to rating.rating
    
    var width: CGFloat = 200
    var height: CGFloat = 100
    var accent = Color.red
    var gradient = LinearGradient(gradient: Gradient(colors: [Color.pPurple, Color.pPurple]),
                                  startPoint: .top, endPoint: .bottom)
    
    var onDismiss: () 
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .frame(width: width, height: height)
            .shadow(radius: 8)
            .overlay(gradient)
            .overlay(
                VStack {
                    
                    StarSliderTextView(value: $value)
                        .padding(.top)
                    StarSliderView(value: $value, accent: accent)
                        .padding(.horizontal)
                    StarSliderButtons(movie: movie, value: $value)
                    
                }
                
            ) // Slider Stack
        
            
            
            

                
                
                
        
        

    }
}

struct StarSlider_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
//            StarSlider()

        }.previewLayout(.sizeThatFits)
        

    }
}


// Textview to display slider value
struct StarSliderTextView: View {
    
    @Binding var value: Double
    
    var body: some View {
        
        HStack {
            Image(systemName: "star.fill").resizable()
                .foregroundColor(.pGray3)
                .frame(width: 30, height: 30)
            
            Text("\(value, specifier: "%.1f")")
                .font(.title).fontWeight(.light)
                .frame(width: 60, height: 40, alignment: .center)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        
        
    }
}


// View to show slider view
struct StarSliderView: View {
    
    @Binding var value: Double
    var accent = Color.blue
    
    var body: some View {
        
        HStack {
            Button(action: {
                    if value >= 0.1 {
                        value -= 0.1 } },
                   label: {
                    Image(systemName: "minus.circle").resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .font(Font.title.weight(.light))
                        .foregroundColor(.pGray3)
                   })
            
            Slider(value: $value, in: 0...5, step: 0.5)
            
            Button(action: {
                if value <= 4.9 {
                    value += 0.1
                }
            },
            label: {
                Image(systemName: "plus.circle").resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .font(Font.title.weight(.light))
                    .foregroundColor(.pGray3)
            })
        }
        .padding(.horizontal, 5)
        .padding(.vertical)
        
    }
    
}


// Action buttons for view
struct StarSliderButtons: View {
    
    var ratingStore = MovieRatingStore()
    var movie: Movie
    @Binding var value: Double
    
    var body: some View {
        
        HStack {
            
            // Cancel
            Button(action: {
                print("Cancel")
                
//                self.dismiss.toggle()
            }, label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.lightBlue)
                    .shadow(radius: 3)
                    .overlay(
                        Text("Cancel").bold().foregroundColor(.pGray3).opacity(0.8)
                    )
            })
            
            Spacer()
            
            // Save Button
            Button(action: {
                print("Submit")
                
                movie.rating = value
                print("Submit - Rating.rating = \(movie.rating)")
                ratingStore.saveContext()
                
            }, label: {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.lightBlue)
                    .shadow(radius: 3)
                    .overlay(
                        Text("Submit").bold().foregroundColor(.pGray3).opacity(0.8)
                )
            })
            
            
            
        }
        .padding()
        
    }
}
