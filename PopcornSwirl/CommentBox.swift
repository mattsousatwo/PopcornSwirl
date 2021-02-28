//
//  CommentBox.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 2/18/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct CommentBox: View {
    
    var movie: Movie?
    @Binding var text: String
    
    var width: CGFloat = UIScreen.main.bounds.width - 20
    var height: CGFloat = UIScreen.main.bounds.height / 4
    var color: Color = .purple
    var shadowRadius: CGFloat = 8
    
    func commentBody(_ comment: String) -> some View {
        return RoundedRectangle(cornerRadius: 12.0)
            .foregroundColor(color)
            .frame(width: width,
                   height: height,
                   alignment: .top)
            .shadow(radius: shadowRadius)
            .overlay(
                TextField(comment, text: $text)
                    .fixedSize(horizontal: false,
                               vertical: true)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.pGray3)
                    .padding()
                    .padding(.trailing, 20)
                    .frame(height: height, alignment: .topLeading)
                )
    }
    
    var body: some View {
        
        if let comment = movie?.comment {
            commentBody(comment)
        } else {
            commentBody("New Comment")
        }
        
    }
}

struct CommentBox_Previews: PreviewProvider {
    static var previews: some View {
        CommentBox(movie: nil, text: .constant("") )
    }
}
