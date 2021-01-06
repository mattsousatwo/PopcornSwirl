//
//  RemoteImage.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/20/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct RemoteImage: View {
    
    private enum LoadState {
        case loading, success, failure
    }
    
    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading
        
        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }
            
            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }
                
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            } .resume()
            
        }
    }
    
    @StateObject private var loader: Loader
    var loading: UIImage
    var failure: UIImage
    
    
    var body: some View {
        Image(uiImage: selectedImage()).resizable()
    }
    
    init(url: String,
         loading: UIImage = UIImage(systemName: "photo")!,
         failure: UIImage = UIImage(systemName: "multiply.circle")!) {
        
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
        
    }
    
    private func selectedImage() -> UIImage {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return image
            } else {
                return failure
            }
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "default")
    }
}

// View to display movie posters
struct RemotePoster: View {
    let url: String
    @State var isFavorite: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            RemoteImage(url: url).clipShape( RoundedRectangle(cornerRadius: 12) )
//                .aspectRatio(contentMode: .fil)
                .frame(width: 150, height: 250)
                .shadow(radius: 5)
                .overlay(
                    Button(action: {
                        self.isFavorite.toggle()
                    }, label: {
                        HeartButton(type: isFavorite ? .fill : .empty)
                            .frame(width: 25, height: 25)
                            .padding()

                            .shadow(radius: 5.0)
                    })
                
                    , alignment: .bottomTrailing)
            
        }
    }
}

// View to display movie actors 
struct RemoteActor: View {
    let url: String
    var name: String
    var subtitle: String
    @State var isFavorite: Bool
    
    private var s : Bool {
        return true
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            
            RemoteImage(url: url).clipShape( RoundedRectangle(cornerRadius: 12) )
//                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 250)
                .shadow(radius: 5)
            
                .overlay(
                    Button(action: {
                        self.isFavorite.toggle() 
                    }, label: {
                        HeartButton(type: isFavorite ? .fill : .empty)
                            .frame(width: 25, height: 25)
                            .padding()

                    })
                    , alignment: .bottomTrailing )
            VStack {
                Text(name)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .frame(width: 140,
                           height: 40)
                    .foregroundColor(.pGray3)
                
                    
                Text(subtitle)
                    .foregroundColor(.pGray3)
                    .opacity(0.7)
            
            }
            .frame(width: 140, height: 60, alignment: .center)
        }
    }
    
    
    
    
}
 
