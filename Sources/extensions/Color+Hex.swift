import Foundation
import SwiftUI

/// A custom initializer for `Color` that accepts a hex string to create a color.
extension Color {
    init(hex: String) {
        // Remove the leading "#" if present
        let hexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        // Ensure the hex string is exactly 6 characters (valid RGB hex code)
        guard hexString.count == 6, let rgb = UInt64(hexString, radix: 16) else {
            self.init(red: 0, green: 0, blue: 0) 
            return
        }
        
        // Extract red, green, and blue components
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
