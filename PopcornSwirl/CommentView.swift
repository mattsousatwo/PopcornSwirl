//
//  CommentView.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 3/22/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct CommentView: View {
    
    
    @Binding var value: Double
    @Binding var text: String
    
    
    init(value: Binding<Double>, text: Binding<String>) {
        self._value = value
        self._text = text
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
            Section {
                TextEditor(text: $text)
                    .frame(height: 150)
            }
            
            Section {
                HStack {
                    Spacer()
                    Text("\(value, specifier: "%.1f")")
                        .padding()
                    Spacer()
                }
                
                
                HStack {
                    
                    minusButton()
                    
                    Slider(value: $value, in: 0...5, step: 0.5) { (valueIsChanged) in
                        if valueIsChanged == true {
                            self.hideKeyboard()
                        }
                    }
                    
                    plusButton()
                    
                }
                .padding(.horizontal, 5)
                .padding(.vertical)
                
            }
            
            Button("Save") {
                
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(15)
            .shadow(radius: 2)
            
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        
        
        
        
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(value: .constant(2), text: .constant("Placeholder"))
    }
}
