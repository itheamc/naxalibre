//
//  NaxaLibreMapOptionsArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre

/// Object responsible for parsing arguments provided to configure a MapLibre map.
///
/// This struct provides a utility function `parseArgs` that takes a dictionary of arguments
/// and constructs a `MapLibreMapOptions` object based on these arguments. It handles parsing various
/// map options, including camera position, zoom and pitch limits, pixel ratio, and boolean flags.
struct NaxaLibreMapOptionsArgsParser {
    
    /// Parses a dictionary of arguments to create a `MapLibreMapOptions` object.
    ///
    /// - Parameters:
    ///   - args: An optional dictionary containing key-value pairs representing the map's configuration.
    ///           If nil, default options are created.
    ///           The supported keys and their types are:
    ///
    /// - Returns: A `MapLibreMapOptions` object configured with the provided arguments or default values.
    static func parseArgs(_ args: [String: Any?]?) -> NaxaLibreMapOptions {
        var options = NaxaLibreMapOptions()
        
        guard let optionArgs = args else {
            return options
        }
        
        // Parse camera position if provided
        if let cameraArgs = optionArgs["position"] as? [String: Any] {
            let camera = NaxaLibreMapCameraArgsParser.parseArgs(cameraArgs)
            options.position = camera
        }
        
        // Parse zoom limits
        if let minZoom = optionArgs["minZoom"] as? Double {
            options.minZoom = minZoom
        }
        
        if let maxZoom = optionArgs["maxZoom"] as? Double {
            options.maxZoom = maxZoom
        }
        
        // Parse pitch limits
        if let minPitch = optionArgs["minPitch"] as? Double {
            options.minPitch = minPitch
        }
        
        if let maxPitch = optionArgs["maxPitch"] as? Double {
            options.maxPitch = maxPitch
        }
        
        // Parse pixel ratio
        if let pixelRatio = optionArgs["pixelRatio"] as? Double {
            options.pixelRatio = pixelRatio
        }
        
        // Parse boolean flags
        if let textureMode = optionArgs["textureMode"] as? Bool {
            options.textureMode = textureMode
        }
        
        if let debugActive = optionArgs["debugActive"] as? Bool {
            options.debugActive = debugActive
        }
        
        if let crossSourceCollisions = optionArgs["crossSourceCollisions"] as? Bool {
            options.crossSourceCollisions = crossSourceCollisions
        }
        
        if let renderSurfaceOnTop = optionArgs["renderSurfaceOnTop"] as? Bool {
            options.renderSurfaceOnTop = renderSurfaceOnTop
        }
        
        return options
    }
}


extension MLNMapView {
    func applyMapOptions(_ options: NaxaLibreMapOptions) {
        self.minimumZoomLevel = options.minZoom
        self.maximumZoomLevel = options.maxZoom
        self.minimumPitch = options.minPitch
        self.maximumPitch = options.maxPitch
        
        if let position = options.position {
            if position.target.latitude != 0 && position.target.longitude != 0 {
                self.setCenter(position.target, zoomLevel: position.zoom, animated: true)
            }
        }
        
        if let pixelRatio = options.pixelRatio {
            self.contentScaleFactor = pixelRatio
        }
    }
}

