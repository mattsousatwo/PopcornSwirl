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


    public static let lightYellow = Color(red: 236, green: 204, blue: 104)
    public static let orange = Color(red: 255, green: 165, blue: 2)
    public static let coral = Color(red: 255, green: 127, blue: 80)
    public static let darkOrange = Color(red: 255, green: 99, blue: 72)
    public static let lightPink = Color(red: 255, green: 107, blue: 129)
    public static let watermelonRed = Color(red: 255, green: 71, blue: 87)
    public static let lime = Color(red: 123, green: 237, blue: 159)
    public static let darkLime = Color(red: 46, green: 123, blue: 115)
    public static let lightBlue = Color(red: 112, green: 161, blue: 255)
    public static let darkBlue = Color(red: 30, green: 144, blue: 255)
    public static let pPurple = Color(red: 83, green: 82, blue: 237)
    public static let indigo = Color(red: 55, green: 66, blue: 250)
    public static let snowWhite = Color(red: 255, green: 255, blue: 255)
    public static let pGray = Color(red: 241, green: 242, blue: 246)
    public static let pGray2 = Color(red: 223, green: 228, blue: 234)
    public static let pGray3 = Color(red: 206, green: 214, blue: 224)
    
    
    // public static let name = Color(red: <#T##Double#>, green: <#T##Double#>, blue: <#T##Double#>)
    
    
}
