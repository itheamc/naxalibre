//
//  NaxaLibreMapOptions.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation


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
