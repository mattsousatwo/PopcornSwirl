//
//  MovieCard.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct MoviePoster: View {

    @ObservedObject var urlImageModel: URLImageModel
    
    init(urlString: String?) {
        urlImageModel = URLImageModel(url: urlString)
    }
    
    var body: some View {
        
        switch urlImageModel.image {
        case nil:
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 150, height: 300)
                .foregroundColor(.blue)
                .shadow(radius: 5)
        default:
            Image(uiImage: urlImageModel.image!).resizable().clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .frame(width: 150,
                   height: 300)
            .shadow(radius: 5)
        }
        
    }
}

// Used to display movie poster
struct Poster: View {
    
    @ObservedObject var urlImageModel: URLImageModel
    
    var title = String()
    
    init(urlString: String?, title: String) {
        urlImageModel = URLImageModel(url: urlString)
        self.title = title
    }
    
    var body: some View {
        switch urlImageModel.image {
        case nil:
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 150, height: 300)
                .foregroundColor(Color.coral)
                .shadow(radius: 5)
            
        default:
            VStack(alignment: .leading) {
                Image(uiImage: urlImageModel.image!).resizable().clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                
                .frame(width: 150, height: 250)
                .shadow(radius: 5)
                
                    
                Text(title).foregroundColor(.black).lineLimit(2).fixedSize(horizontal: false, vertical: true )
                        .frame(width: 150, height: 50)
                

            }
            .frame(width: 150, height: 300)
            
        }

    }
    
    
}

struct ActorCard: View {
    
    var color: Color = Color.yellow
    var image: Image = Image(systemName: "globe")
    var width: CGFloat = 100
    var height: CGFloat = 200
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 100, height: 200)
            .foregroundColor(Color.pGray)
            .shadow(radius: 5)
            .overlay(
            
                VStack {
                Text("Actor Name").font(.body).padding()
                
                HStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: width / 12,
                            height: height - (height / 3) )
                        .foregroundColor(color)
                        
                        image.resizable()
                            .padding()
                    
                    }
                
                }
                
                , alignment: .bottomLeading)
        
    }
    
}


struct ActorCard2: View {
    
    var color: Color = Color.yellow
    var image: Image = Image(systemName: "globe")
    var width: CGFloat = 100
    var height: CGFloat = 200
    var title: String = "Names"
    var subtitle: String = "20 Movies"
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 100, height: 200)
            .foregroundColor(Color.pGray)
            .shadow(radius: 5)
            .overlay(

                
                HStack(alignment: .bottom) {
                    
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: width / 20,
                            height: height )
                        .foregroundColor(color)
                        
                    
                    
                    VStack(alignment: .leading) {
                        
                        Spacer()
                        
                        image.clipShape(RoundedRectangle(cornerRadius: 12)).shadow(radius: 5)
                            .frame(width: 25, height: 50)
                        Spacer()
                        
                        Text(title).font(.system(size: 18))
                        Text(subtitle).font(.system(size: 8))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "bookmark")
                            Spacer()
                            Text("More").font(.caption)
                        }
                        
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
                    
                    
                }
                
                
                , alignment: .leading)
        
    }
    
}


struct ActorCard3: View {
    
    var color: Color = Color.yellow
    var image: Image = Image(systemName: "globe")
    var width: CGFloat = 100
    var height: CGFloat = 200
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 100, height: 200)
            .foregroundColor(Color.pGray)
            .shadow(radius: 5)
            .overlay(

                
                HStack(alignment: .bottom) {
                    
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: width / 20,
                            height: height )
                        .foregroundColor(color)
                        
                    
                    
                    VStack(alignment: .leading) {
                        
                        Spacer()
                        
                        image.clipShape(RoundedRectangle(cornerRadius: 12)).shadow(radius: 5)
                            .frame(width: 25, height: 50)
                        Spacer()
                        
                        Text("Names").font(.system(size: 18))
                        Text("73 Movies").font(.system(size: 8))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "bookmark")
                            Spacer()
                            Text("More").font(.caption)
                        }
                        
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
                    
                    
                }
                
                
                , alignment: .leading)
        
    }
    
}

struct Actor: View {

    @ObservedObject var actorImage: URLImageModel
    var name: String
    var subtitle: String
    @Binding var favorite: Bool
    
    init(imageURL: String?, name: String, subtitle: String, favorite: Binding<Bool>) {
        actorImage = URLImageModel(url: imageURL)
        self.name = name
        self._favorite = favorite
        self.subtitle = subtitle
    }
    
    var body: some View {
        
        switch actorImage.image {
        case nil:
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 100,
                       height: 200)
                .foregroundColor(.darkBlue)
                .shadow(radius: 5)

        default:
            VStack {
                
                Image(uiImage: actorImage.image!).resizable().clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
                .frame(width: 100,
                       height: 200)
                .shadow(radius: 5)

                .overlay(
                    
                    Button(action: {
                        self.favorite.toggle()
                        print("favorite button tapped")
                    }, label: {
                        Image(systemName: favorite ? "heart.fill": "heart")
                            .frame(width: 30, height: 30)
                            .padding()
                            .foregroundColor(.pGray3)
                    })

                    , alignment: .bottomTrailing)
                Text(name)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 100,
                           height: 30,
                           alignment: .center)
                    .foregroundColor(.black)
                Text(subtitle)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80,
                           height: 30,
                           alignment: .center)
                    .foregroundColor(.gray)
            } // VStack
            
        } // switch
        
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            MoviePoster(urlString: nil)
            
            Poster(urlString: nil, title: "")
            
            ActorCard(color: .blue)
            
            ActorCard2(color: .green)
            
            ActorCard3(color: .coral)
            
            Actor(imageURL: nil, name: "Actor Name", subtitle: "Subtitle", favorite: .constant(true))
            
            
        }.previewLayout(.sizeThatFits)
    }
}
