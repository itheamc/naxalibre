//
//  NaxaLibreAltitudeUtils.swift
//  naxalibre
//
//  Created by Amit on 23/02/2025.
//

import Foundation
import MapLibre

/// A collection of utilities for working with MapLibre camera altitudes and zoom levels
enum NaxaLibreAltitudeUtils {
    
    /// Calculates an approximate camera altitude for a given zoom level.
    /// - Parameters:
    ///   - zoomLevel: The zoom level (e.g., 0, 10, 15, etc.).
    ///   - screenHeight: The height of your map view (in points or pixels, consistently used).
    ///   - fieldOfView: The vertical field of view of your camera in degrees (default is 60°).
    /// - Returns: The approximate altitude (in meters).
    static func calculateAltitude(forZoom zoomLevel: Double, screenHeight: Double, fieldOfView: Double = 60.0) -> Double {
        // Resolution at zoom level 0 (meters per pixel at the equator)
        let metersPerPixelAtZoom0 = 156543.03392
        // Compute the meters-per-pixel at the specified zoom level.
        let metersPerPixel = metersPerPixelAtZoom0 / pow(2.0, zoomLevel)
        
        // Convert the field of view from degrees to radians.
        let fovRadians = fieldOfView * .pi / 180.0
        
        // The altitude is derived using the pinhole camera model:
        // (half the screen height in meters) / tan(fov/2)
        let altitude = (screenHeight / 2.0 * metersPerPixel) / tan(fovRadians / 2.0)
        
        return altitude
    }
    
    /// Calculates the approximate altitude (in arbitrary units) for a given zoom level.
    /// - Parameters:
    ///   - zoomLevel: The zoom level (e.g., 0, 1, 2, …).
    ///   - tileSize: The size of the tile in pixels (default is 512).
    ///   - fieldOfViewDegrees: The vertical field-of-view of the camera in degrees (default is 45).
    /// - Returns: The computed altitude.
    static func calculateAltitude(fromZoom zoomLevel: Double, tileSize: Double = 512, fieldOfViewDegrees: Double = 60.0) -> Double {
        // Convert field-of-view from degrees to radians.
        let fieldOfViewRadians = fieldOfViewDegrees * .pi / 180
        // Calculate the altitude at zoom level 0 using the formula.
        let altitudeAtZoomZero = tileSize / (2 * tan(fieldOfViewRadians / 2))
        // Each zoom level doubles the scale factor, effectively halving the altitude.
        return altitudeAtZoomZero / pow(2, zoomLevel)
    }
}
