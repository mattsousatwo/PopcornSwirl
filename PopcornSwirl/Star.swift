//
//  Star.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct Star: View {
    var status: StarStatus
    var body: some View {
        Image(systemName: status.rawValue).resizable()
            .foregroundColor(.lightYellow)
            .frame(width: 25, height: 25)
    }
}


struct StarBar: View {
    
    var value: Double
    
    private var status: [StarStatus] {
        switch value {
        case 0...0.4 :
            return [.empty, .empty, .empty, .empty, .empty]
        case 0.5...0.9 :
            return [.half, .empty, .empty, .empty, .empty]
        case 1...1.4 :
            return [.full, .empty, .empty, .empty, .empty]
        case 1.5...1.9 :
            return [.full, .half, .empty, .empty, .empty]
        case 2...2.4 :
            return [.full, .full, .empty, .empty, .empty]
        case 2.5...2.9 :
            return [.full, .full, .half, .empty, .empty]
        case 3...3.4 :
            return [.full, .full, .full, .empty, .empty]
        case 3.5...3.9 :
            return [.full, .full, .full, .half, .empty]
        case 4...4.4 :
            return [.full, .full, .full, .full, .empty]
        case 4.5...4.9 :
            return [.full, .full, .full, .full, .half]
        case 5:
            return [.full, .full, .full, .full, .full]
        default:
            return [.nonExistant, .nonExistant, .nonExistant, .nonExistant, .nonExistant]
        }
    }
    
    var body: some View {
        HStack {
            ForEach(status, id: \.self) { x in
                Star(status: x)
            }
            Text("\(value, specifier: "%.1f")").font(.system(size: 20)).bold()
            .foregroundColor(.lightYellow)
        }
    }
}



struct Star_Previews: PreviewProvider {
    static var previews: some View {  
        Group {
            StarBar(value: 2.7)
                .previewLayout(.sizeThatFits)
            
            StarBar(value: 3.8)
                .previewLayout(.sizeThatFits)
            
            Star(status: StarStatus.empty)
            .frame(width: 100, height: 100)
                .foregroundColor(Color.lightYellow)
                .previewLayout(.sizeThatFits)
            
            Star(status: .half)
            .frame(width: 100, height: 100)
                .foregroundColor(Color.lightYellow)
                .previewLayout(.sizeThatFits)
            
            
            Star(status: .full)
            .frame(width: 100, height: 100)
                .foregroundColor(Color.lightYellow)
                .previewLayout(.sizeThatFits)
            
        }
    }
}


enum StarStatus: String  {
    case empty = "star"
    case half = "star.lefthalf.fill"
    case full = "star.fill"
    case nonExistant = "star.slash"
}
