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
    
    /// A struct that defines various configuration options for the NaxaLibreMap.
    ///
    /// This struct allows customization of zoom levels, pitch limits, camera position,
    /// rendering behavior, and debug options.
    struct NaxaLibreMapOptions {
        
        /// The minimum zoom level allowed for the map. Default is 0.0.
        var minZoom: Double
        
        /// The maximum zoom level allowed for the map. Default is 25.5.
        var maxZoom: Double
        
        /// The minimum pitch (tilt) angle allowed for the map. Default is 0.0.
        var minPitch: Double
        
        /// The maximum pitch (tilt) angle allowed for the map. Default is 60.0.
        var maxPitch: Double
        
        /// The initial camera position of the map.
        var position: NaxaLibreMapCamera?
        
        /// The pixel ratio for rendering, useful for handling high-density displays.
        var pixelRatio: Double?
        
        /// Whether to use texture mode for rendering. This can improve performance on some devices. Default is false.
        var textureMode: Bool
        
        /// Whether debugging features (e.g., tile borders, FPS display) are enabled. Default is false.
        var debugActive: Bool
        
        /// Whether cross-source collisions are enabled for symbol placement. Default is true.
        var crossSourceCollisions: Bool
        
        /// Whether the render surface is placed on top of other UI elements. Default is false.
        var renderSurfaceOnTop: Bool
        
        /// Creates a `NaxaLibreMapOptions` instance with the specified properties.
        ///
        /// All parameters have default values to enforce explicit configuration.
        init() {
            self.minZoom = 0.0
            self.maxZoom = 25.5
            self.minPitch = 0.0
            self.maxPitch = 60.0
            self.position = nil
            self.pixelRatio = nil
            self.textureMode = false
            self.debugActive = false
            self.crossSourceCollisions = true
            self.renderSurfaceOnTop = false
        }
    }
    
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
    func applyOptions(_ options: NaxaLibreMapOptionsArgsParser.NaxaLibreMapOptions) {
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

