//
//  NaxaLibreMapCameraArgsParser.swift
//  naxalibre
//
//  Created by Amit on 22/02/2025.
//

import Foundation
import MapLibre

/**
 * `NaxaLibreMapCameraArgsParser` is a utility class responsible for parsing a dictionary of arguments
 * and constructing a `NaxaLibreMapCamera` object from them. It expects specific keys within the
 * dictionary to represent camera properties such as target (latitude, longitude), zoom, bearing, tilt, and padding.
 */
struct NaxaLibreMapCameraArgsParser {
    
    /**
     * Parses a dictionary of arguments to construct a `NaxaLibreMapCamera`.
     *
     * This function takes a dictionary of arguments, potentially containing keys for "target", "zoom", "bearing", "tilt", and "padding".
     * It extracts these values, validates their types, and uses them to build a `NaxaLibreMapCamera` object.
     *
     * The expected structure of the arguments dictionary is as follows:
     * - **target**: An `Array` representing latitude and longitude coordinates.
     *   - Example: `[37.7749, -122.4194]` (San Francisco)
     *   - The array must contain exactly two numerical values (latitude, longitude) that can be parsed as Doubles.
     *   - If the array has not exactly two values or some values cannot be parsed as Double, it will be ignored.
     * - **zoom**: A numerical value representing the zoom level.
     *   - Example: `10.5`
     *   - Must be convertible to a Double.
     *   - if the value cannot be parsed as Double, it will be ignored.
     * - **bearing**: A numerical value representing the camera's bearing (rotation).
     *   - Example: `45.0`
     *   - Must be convertible to a Double.
     *   - if the value cannot be parsed as Double, it will be ignored.
     * - **tilt**: A numerical value representing the camera's tilt angle.
     *   - Example: `30.0`
     *   - Must be convertible to a Double.
     *   - if the value cannot be parsed as Double, it will be ignored.
     * - **padding**: An `Array` representing the padding in pixels for the map view: `[left, top, right, bottom]`.
     *   - Example: `[10.0, 20.0, 10.0, 20.0]`
     *   - The array must contain exactly four numerical values that can be parsed as Doubles.
     *   - If the array has not exactly four values or some values cannot be parsed as Double, it will be ignored.
     */
    static func parseArgs(_ args: [String: Any]?) -> NaxaLibreMapCamera {
        let target = args?["target"] as? [Any]
        let zoom = args?["zoom"]
        let bearing = args?["bearing"]
        let tilt = args?["tilt"]
        let padding = args?["padding"] as? [Any]
        
        var builder = NaxaLibreMapCamera.Builder()
        
        if let target = target {
            let targetAsDouble = target.compactMap { String(describing: $0).doubleValue }
            if targetAsDouble.count >= 2 {
                let latLng = CLLocationCoordinate2D(latitude: targetAsDouble[0], longitude: targetAsDouble[1])
                builder = builder.setTarget(latLng)
            }
        }
        
        if let zoom = zoom {
            let zoomAsDouble = String(describing: zoom).doubleValue
            if let zoomAsDouble = zoomAsDouble {
                builder = builder.setZoom(zoomAsDouble)
            }
        }
        
        if let bearing = bearing {
            let bearingAsDouble = String(describing: bearing).doubleValue
            if let bearingAsDouble = bearingAsDouble {
                builder = builder.setBearing(bearingAsDouble)
            }
        }
        
        if let tilt = tilt {
            let tiltAsDouble = String(describing: tilt).doubleValue
            if let tiltAsDouble = tiltAsDouble {
                builder = builder.setTilt(tiltAsDouble)
            }
        }
        
        if let padding = padding {
            let paddingAsFloats = padding.compactMap { String(describing: $0).floatValue }
            if paddingAsFloats.count == 4 {
                let edgeInsets = UIEdgeInsets(top: CGFloat(paddingAsFloats[1]), left: CGFloat(paddingAsFloats[0]), bottom: CGFloat(paddingAsFloats[3]), right: CGFloat(paddingAsFloats[2]))
                builder = builder.setPadding(edgeInsets)
            }
        }
        
        return builder.build()
    }
}

// Extension to help with string to double conversion
fileprivate extension String {
    var doubleValue: Double? {
        return Double(self)
    }
    
    var floatValue: Float? {
        return Float(self)
    }
}
