//
//  View+EXT.swift
//  PopcornSwirl
//
//  Created by Matthew Sousa on 12/25/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import UIKit
import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


