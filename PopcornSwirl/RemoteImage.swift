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
    var loading: Image
    var failure: Image
    
    var body: some View {
        selectedImage()
            .resizable()
    }
    
    init(url: String,
         loading: Image = Image(systemName: "photo"),
         failure: Image = Image(systemName: "multiply.circle")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }
    
    private func selectedImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
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


struct RemotePoster: View {
    let url: String
    
    var body: some View {
        VStack(alignment: .leading) {
            RemoteImage(url: url).clipShape( RoundedRectangle(cornerRadius: 12) )
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 250)
                .shadow(radius: 5)
        }
    }
}

struct RemoteActor: View {
    let url: String
    
    var body: some View {
        VStack(alignment: .leading) {
            RemoteImage(url: url).clipShape( RoundedRectangle(cornerRadius: 12) )
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 250)
                .shadow(radius: 5)
        }
    }
}
