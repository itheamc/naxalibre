//
//  ExtensionFunctions.swift
//  naxalibre
//
//  Created by Amit on 19/02/2025.
//

import Foundation
import MapLibre

extension MLNCameraChangeReason {
    func toFlutterCode() -> Int64 {
        // Check for gesture-related reasons
        if self.contains(MLNCameraChangeReason.gesturePan) ||
            self.contains(MLNCameraChangeReason.gesturePinch) ||
            self.contains(MLNCameraChangeReason.gestureRotate) ||
            self.contains(MLNCameraChangeReason.gestureZoomIn) ||
            self.contains(MLNCameraChangeReason.gestureZoomOut) ||
            self.contains(MLNCameraChangeReason.gestureOneFingerZoom) ||
            self.contains(MLNCameraChangeReason.gestureTilt) {
            return Int64(1) // apiGesture
        }
        
        // Check for programmatic changes
        if self.contains(MLNCameraChangeReason.programmatic) {
            return Int64(3) // apiAnimation
        }
        
        // Check for developer-triggered animations
        if self.contains(MLNCameraChangeReason.resetNorth) {
            return Int64(2) // developerAnimation
        }
        
        // Default case
        return Int64(0) // unknown
    }
}

extension UIColor {
    /// Dictionary of common color names to their hex values
    private static let colorNameToHex: [String: String] = [
        "black": "#000000",
        "white": "#FFFFFF",
        "red": "#FF0000",
        "green": "#008000",
        "blue": "#0000FF",
        "yellow": "#FFFF00",
        "purple": "#800080",
        "orange": "#FFA500",
        "gray": "#808080",
        "grey": "#808080",
        "pink": "#FFC0CB",
        "brown": "#A52A2A",
        "cyan": "#00FFFF",
        "magenta": "#FF00FF",
        "lime": "#00FF00",
        "navy": "#000080",
        "teal": "#008080",
        "olive": "#808000",
        "maroon": "#800000",
        "silver": "#C0C0C0",
        "indigo": "#4B0082",
        "violet": "#EE82EE",
        "tan": "#D2B48C",
        "aqua": "#00FFFF",
        "gold": "#FFD700",
        "coral": "#FF7F50",
        "salmon": "#FA8072",
        "khaki": "#F0E68C",
        "turquoise": "#40E0D0"
    ]
    
    /// Creates a UIColor from a color name or hex string
    /// - Parameters:
    ///   - colorNameOrHex: A color name (e.g., "red") or hex string (e.g., "#FF0000")
    ///   - defaultColor: Optional fallback color to use if parsing fails (returns nil if not provided)
    /// - Returns: A UIColor instance or nil if string couldn't be parsed and no default was provided
    convenience init?(colorNameOrHex: String, defaultColor: UIColor? = nil) {
        let colorString = colorNameOrHex.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Check if it's a named color
        if let hexValue = UIColor.colorNameToHex[colorString] {
            self.init(hexString: hexValue, defaultColor: defaultColor)
            return
        }
        
        // Otherwise treat as hex string
        self.init(hexString: colorString, defaultColor: defaultColor)
    }
    
    /// Creates a UIColor from a hex string with format "#RRGGBB" or "#RRGGBBAA"
    /// - Parameters:
    ///   - hexString: The hex color string
    ///   - defaultColor: Optional fallback color to use if parsing fails (returns nil if not provided)
    /// - Returns: A UIColor instance or nil if string couldn't be parsed and no default was provided
    convenience init?(hexString: String, defaultColor: UIColor? = nil) {
        // Handle different formats - with or without # prefix
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        // Support for short hex formats (#RGB, #RGBA)
        if hexSanitized.count == 3 || hexSanitized.count == 4 {
            var expandedHex = ""
            for char in hexSanitized {
                expandedHex.append(String(repeating: String(char), count: 2))
            }
            hexSanitized = expandedHex
        }
        
        // Early return for invalid hex length
        // Supported formats after sanitizing: 3, 4, 6, or 8 characters
        // (3: RGB, 4: RGBA, 6: RRGGBB, 8: RRGGBBAA)
        let validLengths = [3, 4, 6, 8]
        guard validLengths.contains(hexSanitized.count) else {
            if let defaultColor = defaultColor {
                self.init(cgColor: defaultColor.cgColor)
                return
            }
            return nil
        }
        
        // Parse the hex value
        var rgbValue: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgbValue) else {
            if let defaultColor = defaultColor {
                self.init(cgColor: defaultColor.cgColor)
                return
            }
            return nil
        }
        
        // Extract color components
        let hasAlpha = hexSanitized.count == 8
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat
        
        if hasAlpha {
            r = CGFloat((rgbValue & 0xFF00_0000) >> 24) / 255.0
            g = CGFloat((rgbValue & 0x00FF_0000) >> 16) / 255.0
            b = CGFloat((rgbValue & 0x0000_FF00) >> 8) / 255.0
            a = CGFloat(rgbValue & 0x0000_00FF) / 255.0
        } else {
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            a = 1.0
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// Returns the hex string representation of the color
    var hexString: String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = components.count >= 4 ? Float(components[3]) : Float(1.0)
        
        if a < 1.0 {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255),
                          lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX",
                          lroundf(r * 255),
                          lroundf(g * 255),
                          lroundf(b * 255))
        }
    }
    
    /// Creates a slightly lighter version of this color
    func lighter(by percentage: CGFloat = 0.2) -> UIColor {
        return self.adjust(by: abs(percentage))
    }
    
    /// Creates a slightly darker version of this color
    func darker(by percentage: CGFloat = 0.2) -> UIColor {
        return self.adjust(by: -abs(percentage))
    }
    
    /// Adjusts the color by the given percentage
    private func adjust(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage, 1.0),
                           green: min(green + percentage, 1.0),
                           blue: min(blue + percentage, 1.0),
                           alpha: alpha)
        }
        
        return self
    }
    
    /// Returns a color name if it closely matches a known color, otherwise returns nil
    var closestColorName: String? {
        // Get the hex representation of this color
        let thisHex = self.hexString
        
        // Find the closest match by comparing hex values
        // This is a simple implementation - for true color distance, you'd use a color space like Lab
        var bestMatch: String? = nil
        var smallestDifference = Double.greatestFiniteMagnitude
        
        for (name, hex) in UIColor.colorNameToHex {
            guard let namedColor = UIColor(hexString: hex) else { continue }
            let namedHex = namedColor.hexString
            
            // A very simple RGB distance calculation
            if let distance = hexColorDistance(hex1: thisHex, hex2: namedHex) {
                if distance < smallestDifference {
                    smallestDifference = distance
                    bestMatch = name
                }
            }
        }
        
        // Only return a match if it's reasonably close
        return smallestDifference < 0.15 ? bestMatch : nil
    }
    
    /// Calculates a simple distance between two hex colors
    private func hexColorDistance(hex1: String, hex2: String) -> Double? {
        guard let color1 = UIColor(hexString: hex1),
              let color2 = UIColor(hexString: hex2) else {
            return nil
        }
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // Simple Euclidean distance in RGB space (not perceptually accurate)
        let rDiff = r1 - r2
        let gDiff = g1 - g2
        let bDiff = b1 - b2
        
        return sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff)
    }
    
    /// Creates a UIColor from a int value
    convenience init(rgb: Int64) {
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    /// Static method to get color from the int or string value
    /// - Parameters:
    ///   - value: String or Int64 value:
    ///
    /// - Returns: A `UIColor` object as per the given value or nil.
    static func from(value: Any?) -> UIColor? {
        if let color = value as? Int64 {
            return UIColor(rgb: color)
        }
        
        if let color = value as? String {
            return UIColor(colorNameOrHex: color)
        }
        
        return nil
    }
}
