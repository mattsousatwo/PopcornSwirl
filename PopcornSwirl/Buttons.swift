//
//  Buttons.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/24/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct CustomButton: View {
    
    @State var pressed: Bool = false
    
    var width: CGFloat = 50
    var height: CGFloat = 50
    var trueImage: String = "person.fill"
    var falseImage: String = "person"
    
    var body: some View {
        
        Image(systemName: pressed ? falseImage : trueImage).resizable().scaledToFit()
            .opacity( pressed ?  1.0 : 0.7)
//            .scaleEffect( pressed ? CGSize(width: 0.8, height: 0.8) : CGSize(width: 1.0, height: 1.0))
            .padding()
            .frame(width: width, height: height)
            .background(Color.lightBlue)
            .foregroundColor(.snowWhite)
            .cornerRadius(8)
            .shadow(radius: pressed ?  0 : 3 )
            .animation(.easeInOut)
        
            .onTapGesture {
                self.pressed.toggle()
            }
        
        }
    
}


struct WatchedButton: View {
    
    var pressed: Bool = false
    
    
    var body: some View {
        
        CustomButton(pressed: pressed,
                     width: 60,
                     height: 60 ,
                     trueImage: "film",
                     falseImage: "film")
    }
    
}

struct BookmarkButton: View {
    
    var pressed: Bool = false 
    
    var body: some View {
        
        CustomButton(pressed: pressed,
                     width: 60,
                     height: 60,
                     trueImage: "bookmark.fill",
                     falseImage: "bookmark.fill")
        
    }
}

struct PlayButton: View {
    
    var pressed: Bool
    
    var body: some View {
        
        CustomButton(pressed: pressed,
                     width: 60,
                     height: 60,
                     trueImage: "play.fill",
                     falseImage: "play.fill")
        
    }
}


struct RecognitionField: View {
    
    @Binding var pressed: Bool
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width,
                   height: 100)
            .background(Color.pGray2)
            .overlay(
                Text("animated")
                    .padding()
                , alignment: .center)
            .offset(x: 0, y: pressed ? 0 : 100)
            .animation(.easeInOut)
    }
}


struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CustomButton(pressed: false ).previewLayout(.sizeThatFits)
            CustomButton(pressed: true ).previewLayout(.sizeThatFits)
            
    
            WatchedButton(pressed: true).previewLayout(.sizeThatFits)
            WatchedButton(pressed: false).previewLayout(.sizeThatFits)
            
            BookmarkButton(pressed: true).previewLayout(.sizeThatFits)
            BookmarkButton(pressed: false).previewLayout(.sizeThatFits)
            
            PlayButton(pressed: true).previewLayout(.sizeThatFits)
            PlayButton(pressed: false).previewLayout(.sizeThatFits)
        }
    }
}
