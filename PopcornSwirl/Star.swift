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
//            .foregroundColor(.lightYellow)
            .foregroundColor(.pGray3)
            .frame(width: 20, height: 20)
    }
}


struct StarBar: View {
    
    var value: Double
    
    private var status: [StarStatus] {
        switch value {
        case 0...0.49 :
            return [.empty, .empty, .empty, .empty, .empty]
        case 0.5...0.99 :
            return [.half, .empty, .empty, .empty, .empty]
        case 1...1.49 :
            return [.full, .empty, .empty, .empty, .empty]
        case 1.5...1.99 :
            return [.full, .half, .empty, .empty, .empty]
        case 2...2.49 :
            return [.full, .full, .empty, .empty, .empty]
        case 2.5...2.99 :
            return [.full, .full, .half, .empty, .empty]
        case 3...3.49 :
            return [.full, .full, .full, .empty, .empty]
        case 3.5...3.99 :
            return [.full, .full, .full, .half, .empty]
        case 4...4.49 :
            return [.full, .full, .full, .full, .empty]
        case 4.5...4.99 :
            return [.full, .full, .full, .full, .half]
        case 5:
            return [.full, .full, .full, .full, .full]
        default:
            return [.nonExistant, .nonExistant, .nonExistant, .nonExistant, .nonExistant]
        }
    }
    
    init(value: Double) {
        let dividedValue = value / 2
        self.value = dividedValue
    }
    
    var body: some View {
        HStack {
            ForEach(status, id: \.self) { x in
                Star(status: x)
            }
            Text("\(value, specifier: "%.1F")").font(.system(size: 20)).bold()
            .foregroundColor(.pGray3)
        }
    }
}



struct Star_Previews: PreviewProvider {
    static var previews: some View {  
        Group {
            StarBar(value: 5.8)
                .previewLayout(.sizeThatFits)
            
            StarBar(value: 9.8)
                .frame(width: 300, height: 20)
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
