//
//  CommentView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 3/22/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct CommentView: View {
    
    

    var movie: Movie
    @Binding var isPresented: Bool
    
    @State private var value: Double
    @State private var text: String
    
    init(movie: Movie, isPresented: Binding<Bool>) {
        
        self.movie = movie
        self._isPresented = isPresented
        
        var rating = 0.0
        if movie.rating == 0 {
            rating = movie.voteAverage / 2
        } else {
            rating = movie.rating
        }
        
        _value = State<Double>.init(initialValue: rating)
        
        if let comment = movie.comment {
            _text = State<String>.init(initialValue: comment)
        } else {
            _text = State<String>.init(initialValue: "New Comment")
        }
//
//        UITableView.appearance().backgroundColor = .blue
//        UITextView.appearance().backgroundColor = .clear
//
    }
    
    /// Subtract Points to $value
    func minusButton() -> some View {
        Button(action: {
                if value >= 0.1 {
                    value -= 0.1 }
            self.hideKeyboard()
        },
               label: {
                Image(systemName: "minus.circle").resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .font(Font.title.weight(.light))
                    .foregroundColor(.pGray3)
               })
            .buttonStyle(PlainButtonStyle() )
        
    }
    
    /// Add Points to $value
    func plusButton() -> some View {
        Button(action: {
            if value <= 4.9 {
                value += 0.1
            }
            self.hideKeyboard()
        },
        label: {
            Image(systemName: "plus.circle").resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .font(Font.title.weight(.light))
                .foregroundColor(.pGray3)
        })
        .buttonStyle(PlainButtonStyle() )
        
    }
    
    var body: some View {
        
        Form {
            Section(header: Text("Comment") ) {
                TextEditor(text: $text)
                    .frame(height: 150)
            }
            
            Section(header: Text("Rating") ) {
                HStack {
                    Spacer()
                    Text("\(value, specifier: "%.1f")")
                        .padding()
                    Spacer()
                }
                
                
                HStack {
                    
                    minusButton()
                    
                    Slider(value: $value,
                           in: 0...5,
                           step: 0.5) { (valueIsChanged) in
                        if valueIsChanged == true {
                            self.hideKeyboard()
                        }
                    }
                    
                    plusButton()
                    
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
                
            }

            Button(action: {
                if value != movie.rating {
                    movie.update(rating: value)
                }
                if text != movie.comment {
                    movie.update(comment: text)
                }
                
                self.isPresented = false
                    },
                   label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(maxWidth: .infinity,
                               minHeight: 40,
                               alignment: .center)
                        .padding()
                        .foregroundColor(.blue)
                        .shadow(radius: 2)
                        .overlay(
                            Text("Save")
                                .font(.headline)
                                .foregroundColor(.pGray3)
                        )
                   })

            .buttonStyle(PlainButtonStyle() )
            
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        
        
        
        
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(movie: Movie(),
                    isPresented: .constant(true))
         
        
        
    }
}
