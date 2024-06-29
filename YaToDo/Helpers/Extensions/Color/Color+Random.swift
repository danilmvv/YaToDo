//
//  Color+Random.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 28/06/24.
//

import Foundation
import SwiftUI

extension Color {
    static func random() -> Color {
        let hue = Double.random(in: 0...1)
        let saturation = Double.random(in: 0.5...1)
        let brightness = Double.random(in: 0.7...1)
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}
