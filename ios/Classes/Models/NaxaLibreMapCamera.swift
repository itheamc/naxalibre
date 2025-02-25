//
//  NaxaLibreMapCamera.swift
//  naxalibre
//
//  Created by Amit on 22/02/2025.
//

import Foundation
import MapLibre

/// Represents the camera position for the NaxaLibreMap, including target location, zoom level, bearing, tilt, and padding.
public class NaxaLibreMapCamera {
    
    /// The geographical coordinate that the camera is centered on.
    public let target: CLLocationCoordinate2D
    
    /// The zoom level of the camera.
    public let zoom: Double
    
    /// The bearing (rotation) of the camera in degrees.
    public let bearing: Double
    
    /// The tilt (pitch) of the camera in degrees.
    public let tilt: Double
    
    /// The padding applied around the viewport.
    public let padding: UIEdgeInsets
    
    /// Private initializer to enforce object creation via the `Builder` class.
    private init(target: CLLocationCoordinate2D, zoom: Double, bearing: Double, tilt: Double, padding: UIEdgeInsets) {
        self.target = target
        self.zoom = zoom
        self.bearing = bearing
        self.tilt = tilt
        self.padding = padding
    }
    
    /// A builder class for constructing instances of `NaxaLibreMapCamera` with a fluent API.
    public class Builder {
        
        private var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        private var zoom: Double = 0.0
        private var bearing: Double = 0.0
        private var tilt: Double = 0.0
        private var padding: UIEdgeInsets = .zero
        
        /// Initializes a new `Builder` instance.
        public init() {}
        
        /// Sets the target location of the camera.
        ///
        /// - Parameter target: The geographical coordinate for the camera.
        /// - Returns: The builder instance for method chaining.
        public func setTarget(_ target: CLLocationCoordinate2D) -> Builder {
            self.target = target
            return self
        }
        
        /// Sets the zoom level of the camera.
        ///
        /// - Parameter zoom: The zoom level.
        /// - Returns: The builder instance for method chaining.
        public func setZoom(_ zoom: Double) -> Builder {
            self.zoom = zoom
            return self
        }
        
        /// Sets the bearing (rotation) of the camera.
        ///
        /// - Parameter bearing: The bearing in degrees.
        /// - Returns: The builder instance for method chaining.
        public func setBearing(_ bearing: Double) -> Builder {
            self.bearing = bearing
            return self
        }
        
        /// Sets the tilt (pitch) of the camera.
        ///
        /// - Parameter tilt: The tilt in degrees.
        /// - Returns: The builder instance for method chaining.
        public func setTilt(_ tilt: Double) -> Builder {
            self.tilt = tilt
            return self
        }
        
        /// Sets the padding around the viewport.
        ///
        /// - Parameter padding: The `UIEdgeInsets` defining the padding.
        /// - Returns: The builder instance for method chaining.
        public func setPadding(_ padding: UIEdgeInsets) -> Builder {
            self.padding = padding
            return self
        }
        
        /// Constructs a `NaxaLibreMapCamera` instance with the specified parameters.
        ///
        /// - Returns: A configured `NaxaLibreMapCamera` instance.
        public func build() -> NaxaLibreMapCamera {
            return NaxaLibreMapCamera(target: target, zoom: zoom, bearing: bearing, tilt: tilt, padding: padding)
        }
    }
}
