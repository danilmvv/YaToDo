//
//  Color+isDark.swift
//  YaToDo
//
//  Created by Danil Masnaviev on 28/06/24.
//

import Foundation
import SwiftUI

extension Color {
    var isDark: Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        guard UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil) else {
            return false
        }
        
        // Значения отсюда: https://www.w3.org/TR/AERT/#color-contrast
        let lum = 0.299 * red + 0.587 * green + 0.114 * blue
        return lum < 0.5
    }
}
