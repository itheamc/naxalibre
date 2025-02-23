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
    func toHex() -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        let a = components.count >= 4 ? Int(components[3] * 255) : 255
        
        if a < 255 {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
}
