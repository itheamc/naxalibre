//
//  NaxaLibreLocationSettings.swift
//  naxalibre
//
//  Created by Amit on 28/02/2025.
//

import Foundation

/// A class representing the settings for a location component.
///
/// This class encapsulates the configuration for enabling or disabling the location
/// component and provides additional options for customizing its appearance and behavior.
class NaxaLibreLocationSettings {
    /// Whether the location component is enabled.
    let locationEnabled: Bool
    
    /// Whether the authorization should request or not
    let shouldRequestAuthorizationOrPermission: Bool
    
    /// The camera mode for tracking the user's location.
    let cameraMode: Int?
    
    /// The rendering mode for the location component.
    let renderMode: Int?
    
    /// The maximum frames per second (FPS) for location animations.
    let maxAnimationFps: Int?
    
    /// The tilt of the map while tracking the location.
    let tiltWhileTracking: Double?
    
    /// The zoom level of the map while tracking the location.
    let zoomWhileTracking: Double?
    
    /// The configuration options for the location component.
    let locationComponentOptions: NaxaLibreLocationComponentOptions
    
    /// The configuration options for the location engine.
    let locationEngineRequestOptions: NaxaLibreLocationEngineRequestOptions
    
    /// Initializes a new instance of `NaxaLibreLocationSettings`.
    private init(
        locationEnabled: Bool = false,
        shouldRequestAuthorizationOrPermission: Bool = false,
        cameraMode: Int? = 0,
        renderMode: Int? = 0,
        maxAnimationFps: Int? = nil,
        tiltWhileTracking: Double? = nil,
        zoomWhileTracking: Double? = nil,
        locationComponentOptions: NaxaLibreLocationComponentOptions = NaxaLibreLocationComponentOptions.fromArgs([:]),
        locationEngineRequestOptions: NaxaLibreLocationEngineRequestOptions = NaxaLibreLocationEngineRequestOptions.fromArgs([:])
    ) {
        self.locationEnabled = locationEnabled
        self.shouldRequestAuthorizationOrPermission = shouldRequestAuthorizationOrPermission
        self.cameraMode = cameraMode
        self.renderMode = renderMode
        self.maxAnimationFps = maxAnimationFps
        self.tiltWhileTracking = tiltWhileTracking
        self.zoomWhileTracking = zoomWhileTracking
        self.locationComponentOptions = locationComponentOptions
        self.locationEngineRequestOptions = locationEngineRequestOptions
    }
    
    /// Creates a `NaxaLibreLocationSettings` instance from a dictionary.
    ///
    /// - Parameter args: A dictionary containing the location settings.
    /// - Returns: A `NaxaLibreLocationSettings` instance populated with the provided values.
    static func fromArgs(_ args: [String: Any?]) -> NaxaLibreLocationSettings {
        return NaxaLibreLocationSettings(
            locationEnabled: args["locationEnabled"] as? Bool ?? false,
            shouldRequestAuthorizationOrPermission: args["shouldRequestAuthorizationOrPermission"] as? Bool ?? false,
            cameraMode: args["cameraMode"] as? Int,
            renderMode: args["renderMode"] as? Int,
            maxAnimationFps: args["maxAnimationFps"] as? Int,
            tiltWhileTracking: args["tiltWhileTracking"] as? Double,
            zoomWhileTracking: args["zoomWhileTracking"] as? Double,
            locationComponentOptions: NaxaLibreLocationComponentOptions.fromArgs(args["locationComponentOptions"] as? [String: Any?] ?? [:]),
            locationEngineRequestOptions: NaxaLibreLocationEngineRequestOptions.fromArgs(args["locationEngineRequestOptions"] as? [String: Any?] ?? [:])
        )
    }
}


/// A struct representing the configuration options for a location component.
///
/// This struct encapsulates various properties that control the appearance and behavior
/// of a location component, such as pulse animations, colors, elevation, and layer settings.
struct NaxaLibreLocationComponentOptions {
    /// Whether the pulse animation is enabled.
    let pulseEnabled: Bool?
    
    /// Whether the pulse fade effect is enabled.
    let pulseFadeEnabled: Bool?
    
    /// The color of the pulse animation.
    ///
    /// This can be an integer representing an ARGB color or a string representing a
    /// hexadecimal color (e.g., "#RRGGBBAA").
    let pulseColor: Any?
    
    /// The alpha (transparency) value of the pulse animation.
    ///
    /// This value should be between 0.0 (fully transparent) and 1.0 (fully opaque).
    /// Don't have any effect on IOS
    let pulseAlpha: Double?
    
    /// The duration of a single pulse animation in milliseconds.
    /// Don't have any effect on IOS
    let pulseSingleDuration: Double?
    
    /// The maximum radius of the pulse animation in pixels.
    /// Don't have any effect on IOS
    let pulseMaxRadius: Double?
    
    /// The tint color for the foreground icon.
    ///
    /// This can be an integer representing an ARGB color or a string representing a
    /// hexadecimal color (e.g., "#RRGGBBAA").
    let foregroundTintColor: Any?
    
    /// The tint color for the stale state of the foreground icon.
    ///
    /// This can be an integer representing an ARGB color or a string representing a
    /// hexadecimal color (e.g., "#RRGGBBAA").
    let foregroundStaleTintColor: Any?
    
    /// The tint color for the background icon.
    ///
    /// This can be an integer representing an ARGB color or a string representing a
    /// hexadecimal color (e.g., "#RRGGBBAA").
    let backgroundTintColor: Any?
    
    /// The tint color for the stale state of the background icon.
    ///
    /// This can be an integer representing an ARGB color or a string representing a
    /// hexadecimal color (e.g., "#RRGGBBAA").
    let backgroundStaleTintColor: Any?
    
    /// Whether the accuracy animation is enabled.
    /// Don't have any effect on IOS
    let accuracyAnimationEnabled: Bool?
    
    /// The color of the accuracy circle.
    ///
    /// This can be an integer representing an ARGB color or a string representing a
    /// hexadecimal color (e.g., "#RRGGBBAA").
    let accuracyColor: Any?
    
    /// The alpha (transparency) value of the accuracy circle.
    ///
    /// This value should be between 0.0 (fully transparent) and 1.0 (fully opaque).
    let accuracyAlpha: Double?
    
    /// The tint color for the bearing icon.
    ///
    /// This can be an integer representing an ARGB color or a string representing a
    /// hexadecimal color (e.g., "#RRGGBBAA").
    let bearingTintColor: Any?
    
    /// Whether the compass animation is enabled.
    let compassAnimationEnabled: Bool?
    
    /// The elevation of the location component in pixels.
    let elevation: Double?
    
    /// The maximum scale of the icon when zooming in.
    let maxZoomIconScale: Double?
    
    /// The minimum scale of the icon when zooming out.
    let minZoomIconScale: Double?
    
    /// The layer ID above which the location component should be displayed.
    let layerAbove: String?
    
    /// The layer ID below which the location component should be displayed.
    let layerBelow: String?
    
    /// Creates a new instance of NaxaLibreLocationComponentOptions.
    ///
    /// - Parameters:
    ///   - pulseEnabled: Whether the pulse animation is enabled.
    ///   - pulseFadeEnabled: Whether the pulse fade effect is enabled.
    ///   - pulseColor: The color of the pulse animation.
    ///   - pulseAlpha: The alpha (transparency) value of the pulse animation.
    ///   - pulseSingleDuration: The duration of a single pulse animation in milliseconds.
    ///   - pulseMaxRadius: The maximum radius of the pulse animation in pixels.
    ///   - foregroundTintColor: The tint color for the foreground icon.
    ///   - foregroundStaleTintColor: The tint color for the stale state of the foreground icon.
    ///   - backgroundTintColor: The tint color for the background icon.
    ///   - backgroundStaleTintColor: The tint color for the stale state of the background icon.
    ///   - accuracyAnimationEnabled: Whether the accuracy animation is enabled.
    ///   - accuracyColor: The color of the accuracy circle.
    ///   - accuracyAlpha: The alpha (transparency) value of the accuracy circle.
    ///   - bearingTintColor: The tint color for the bearing icon.
    ///   - compassAnimationEnabled: Whether the compass animation is enabled.
    ///   - elevation: The elevation of the location component in pixels.
    ///   - maxZoomIconScale: The maximum scale of the icon when zooming in.
    ///   - minZoomIconScale: The minimum scale of the icon when zooming out.
    ///   - layerAbove: The layer ID above which the location component should be displayed.
    ///   - layerBelow: The layer ID below which the location component should be displayed.
    private init(
        pulseEnabled: Bool? = nil,
        pulseFadeEnabled: Bool? = nil,
        pulseColor: Any? = nil,
        pulseAlpha: Double? = nil,
        pulseSingleDuration: Double? = nil,
        pulseMaxRadius: Double? = nil,
        foregroundTintColor: Any? = nil,
        foregroundStaleTintColor: Any? = nil,
        backgroundTintColor: Any? = nil,
        backgroundStaleTintColor: Any? = nil,
        accuracyAnimationEnabled: Bool? = nil,
        accuracyColor: Any? = nil,
        accuracyAlpha: Double? = nil,
        bearingTintColor: Any? = nil,
        compassAnimationEnabled: Bool? = nil,
        elevation: Double? = nil,
        maxZoomIconScale: Double? = nil,
        minZoomIconScale: Double? = nil,
        layerAbove: String? = nil,
        layerBelow: String? = nil
    ) {
        self.pulseEnabled = pulseEnabled
        self.pulseFadeEnabled = pulseFadeEnabled
        self.pulseColor = pulseColor
        self.pulseAlpha = pulseAlpha
        self.pulseSingleDuration = pulseSingleDuration
        self.pulseMaxRadius = pulseMaxRadius
        self.foregroundTintColor = foregroundTintColor
        self.foregroundStaleTintColor = foregroundStaleTintColor
        self.backgroundTintColor = backgroundTintColor
        self.backgroundStaleTintColor = backgroundStaleTintColor
        self.accuracyAnimationEnabled = accuracyAnimationEnabled
        self.accuracyColor = accuracyColor
        self.accuracyAlpha = accuracyAlpha
        self.bearingTintColor = bearingTintColor
        self.compassAnimationEnabled = compassAnimationEnabled
        self.elevation = elevation
        self.maxZoomIconScale = maxZoomIconScale
        self.minZoomIconScale = minZoomIconScale
        self.layerAbove = layerAbove
        self.layerBelow = layerBelow
    }
    
    /// Creates a new instance of NaxaLibreLocationComponentOptions from a dictionary.
    ///
    /// This static method is useful for deserialization or receiving data from other layers
    /// (e.g., Flutter/Dart). The keys in the dictionary correspond to the property names,
    /// and the values are used to initialize the corresponding properties.
    ///
    /// - Parameter args: A dictionary containing the property values.
    /// - Returns: A new instance of NaxaLibreLocationComponentOptions.
    static func fromArgs(_ args: [String: Any?]) -> NaxaLibreLocationComponentOptions {
        return NaxaLibreLocationComponentOptions(
            pulseEnabled: args["pulseEnabled"] as? Bool,
            pulseFadeEnabled: args["pulseFadeEnabled"] as? Bool,
            pulseColor: args["pulseColor"] as? Any,
            pulseAlpha: args["pulseAlpha"] as? Double,
            pulseSingleDuration: args["pulseSingleDuration"] as? Double,
            pulseMaxRadius: args["pulseMaxRadius"] as? Double,
            foregroundTintColor: args["foregroundTintColor"] as? Any,
            foregroundStaleTintColor: args["foregroundStaleTintColor"] as? Any,
            backgroundTintColor: args["backgroundTintColor"] as? Any,
            backgroundStaleTintColor: args["backgroundStaleTintColor"] as? Any,
            accuracyAnimationEnabled: args["accuracyAnimationEnabled"] as? Bool,
            accuracyColor: args["accuracyColor"] as? Any,
            accuracyAlpha: args["accuracyAlpha"] as? Double,
            bearingTintColor: args["bearingTintColor"] as? Any,
            compassAnimationEnabled: args["compassAnimationEnabled"] as? Bool,
            elevation: args["elevation"] as? Double,
            maxZoomIconScale: args["maxZoomIconScale"] as? Double,
            minZoomIconScale: args["minZoomIconScale"] as? Double,
            layerAbove: args["layerAbove"] as? String,
            layerBelow: args["layerBelow"] as? String
        )
    }
}


/// A struct representing the request options for a location engine.
///
/// This struct encapsulates various parameters that control how frequently and
/// accurately the location engine should provide location updates. It is used
/// to configure the behavior of location tracking.
struct NaxaLibreLocationEngineRequestOptions {
    /// The interval (in milliseconds) at which location updates are requested.
    ///
    /// Defaults to `1000` milliseconds.
    let interval: Int
    
    /// The priority level for location accuracy.
    ///
    /// This determines the trade-off between accuracy and power consumption.
    /// Defaults to [NaxaLibreLocationEngineRequestPriority.highAccuracy].
    let priority: NaxaLibreLocationEngineRequestPriority
    
    /// The minimum displacement (in meters) required to trigger a location update.
    ///
    /// If the device moves less than this distance, no update will be triggered.
    /// Defaults to `40.0` meters.
    let displacement: Double
    
    /// The maximum wait time (in milliseconds) for location updates.
    ///
    /// If a location update is not received within this time, the engine may
    /// provide a cached or less accurate location. Defaults to `1000` milliseconds.
    let maxWaitTime: Int
    
    /// The fastest interval (in milliseconds) at which location updates can be received.
    ///
    /// This sets a lower bound on how frequently updates can occur, even if the
    /// device is moving quickly. Defaults to `1000` milliseconds.
    let fastestInterval: Int
    
    /// The type of location provider to use for retrieving location updates.
    ///
    /// This parameter determines the data source for location information,
    /// such as GPS, network, or a combination of sources.
    let provider: NaxaLibreLocationProvider
    
    /// Creates a new instance of NaxaLibreLocationEngineRequestOptions.
    ///
    /// - Parameters:
    ///   - interval: The interval (in milliseconds) at which location updates are requested. Defaults to `1000` milliseconds.
    ///   - priority: The priority level for location accuracy. Defaults to [NaxaLibreLocationEngineRequestPriority.highAccuracy].
    ///   - displacement: The minimum displacement (in meters) required to trigger a location update. Defaults to `40.0` meters.
    ///   - maxWaitTime: The maximum wait time (in milliseconds) for location updates. Defaults to `1000` milliseconds.
    ///   - fastestInterval: The fastest interval (in milliseconds) at which location updates can be received. Defaults to `1000` milliseconds.
    ///   - provider: The type of location provider to use for retrieving location updates. Defaults to [NaxaLibreLocationProvider.fused].
    private init(
        interval: Int = 1000,
        priority: NaxaLibreLocationEngineRequestPriority = .highAccuracy,
        displacement: Double = 40.0,
        maxWaitTime: Int = 1000,
        fastestInterval: Int = 1000,
        provider: NaxaLibreLocationProvider = .fused
    ) {
        self.interval = interval
        self.priority = priority
        self.displacement = displacement
        self.maxWaitTime = maxWaitTime
        self.fastestInterval = fastestInterval
        self.provider = provider
    }
    
    /// Creates a new instance of NaxaLibreLocationEngineRequestOptions from a dictionary.
    ///
    /// This static method is useful for deserialization or receiving data from other layers
    /// (e.g., Flutter/Dart). The keys in the dictionary correspond to the property names,
    /// and the values are used to initialize the corresponding properties.
    ///
    /// - Parameter args: A dictionary containing the property values.
    /// - Returns: A new instance of NaxaLibreLocationEngineRequestOptions.
    static func fromArgs(_ args: [String: Any?]) -> NaxaLibreLocationEngineRequestOptions {
        let interval = args["interval"] as? Int ?? 1000
        
        let priorityIndex = args["priority"] as? Int ?? 0
        let priority = NaxaLibreLocationEngineRequestPriority(rawValue: priorityIndex) ?? .highAccuracy
        
        let displacement = args["displacement"] as? Double ?? 40.0
        let maxWaitTime = args["maxWaitTime"] as? Int ?? 1000
        let fastestInterval = args["fastestInterval"] as? Int ?? 1000
        
        let providerString = args["provider"] as? String ?? "fused"
        let provider = NaxaLibreLocationProvider(rawValue: providerString) ?? .fused
        
        return NaxaLibreLocationEngineRequestOptions(
            interval: interval,
            priority: priority,
            displacement: displacement,
            maxWaitTime: maxWaitTime,
            fastestInterval: fastestInterval,
            provider: provider
        )
    }
}


/// An enum representing the priority levels for location accuracy.
///
/// These priorities determine the trade-off between accuracy and power consumption
/// when requesting location updates.
enum NaxaLibreLocationEngineRequestPriority: Int {
    /// High accuracy mode.
    ///
    /// Provides the most accurate location updates but consumes the most power.
    case highAccuracy = 0
    
    /// Balanced mode.
    ///
    /// Provides a balance between accuracy and power consumption.
    case balanced = 1
    
    /// Low power mode.
    ///
    /// Reduces power consumption by providing less accurate location updates.
    case lowPower = 2
    
    /// No power mode.
    ///
    /// Minimizes power consumption by providing only passive location updates.
    case noPower = 3
}

/// Represents different location data sources available in mobile and web applications.
///
/// Each provider offers unique characteristics for obtaining geographic location information:
///
/// [gps] Global Positioning System provider
///  - Most accurate location method
///  - Requires direct line of sight to GPS satellites
///  - Works best outdoors
///  - Highest battery consumption
///  - Slowest to provide initial location
///  - Provides precise latitude/longitude
///  - Accuracy: 4-20 meters typically
///  - Requires GPS hardware
///
/// [network] Location derived from cellular tower triangulation
///  - Uses mobile network infrastructure
///  - Less accurate than GPS
///  - Works indoors and in urban areas
///  - Lower battery consumption
///  - Faster initial location
///  - Rough location estimation
///  - Accuracy: 100-1000 meters
///  - Requires active network connection
///
/// [fused] Combines multiple location sources intelligently
///  - Dynamically selects best provider
///  - Balances accuracy and battery efficiency
///  - Can quickly switch between GPS, network, and sensors
///  - Recommended for most modern applications
///  - Adaptive to current context and device capabilities
///  - Most battery-efficient option
///
/// [passive] Receives location updates from other apps
///  - Lowest battery consumption
///  - No direct location requests
///  - Uses location data already retrieved by other applications
///  - Useful for background services
///  - Unpredictable update frequency
///  - Best for non-critical location tracking
enum NaxaLibreLocationProvider: String {
    /// Satellite-based precise location
    case gps = "gps"
    
    /// Cell tower-based approximate location
    case network = "network"
    
    /// Intelligent multi-source location
    case fused = "fused"
    
    /// Background location listening
    case passive = "passive"
}
