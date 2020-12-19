//
//  Colors+EXT.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 9/22/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI



extension Color {

public init(red: Int, green: Int, blue: Int, opacity: Double = 1.0) {
    
    let redVal = Double(red) / 255.0
    let grnVal = Double(green) / 255.0
    let bluVal = Double(blue) / 255.0
    
    self.init(red: redVal, green: grnVal, blue: bluVal, opacity: opacity)

    }


    public static let orange = Color(red: 255, green: 165, blue: 2)
    public static let coral = Color(red: 255, green: 127, blue: 80)
    public static let lightPink = Color(red: 255, green: 107, blue: 129)
    public static let watermelonRed = Color(red: 255, green: 71, blue: 87)
    public static let lime = Color(red: 123, green: 237, blue: 159)
    public static let darkLime = Color(red: 46, green: 123, blue: 115)
    public static let pPurple = Color(red: 83, green: 82, blue: 237)
    public static let indigo = Color(red: 55, green: 66, blue: 250)
    public static let snowWhite = Color(red: 255, green: 255, blue: 255)
    public static let pGray = Color(red: 241, green: 242, blue: 246)
    public static let pGray2 = Color(red: 223, green: 228, blue: 234)
    public static let pGray3 = Color(red: 206, green: 214, blue: 224)
    
    
    public static let lightRed = Color(red: 231, green: 76, blue: 60)
    
    public static let darkRed = Color(red: 192, green: 57, blue: 43)
    
    public static let lightGreen = Color(red: 46, green: 204, blue: 96)
    
    public static let darkGreen = Color(red: 39, green: 174, blue: 96)
    
    public static let lightPurple = Color(red: 155, green: 89, blue: 182)
    
    public static let darkPurple = Color(red: 142, green: 68, blue: 173)
    
    public static let lightBlue = Color(red: 52, green: 152, blue: 219)
    
    public static let darkBlue = Color(red: 41, green: 128, blue: 185)
    
    public static let lightYellow = Color(red: 241, green: 196, blue: 15)
    
    public static let darkYellow = Color(red: 243, green: 156, blue: 18)
    
    public static let lightOrange = Color(red: 230, green: 126, blue: 34)
    
    public static let darkOrange = Color(red: 211, green: 84, blue: 0)
    
    public static let purpleBG = Color(red: 69, green: 51, blue: 201)
    
    // public static let name = Color(red: <#T##Double#>, green: <#T##Double#>, blue: <#T##Double#>)
    
    
}
