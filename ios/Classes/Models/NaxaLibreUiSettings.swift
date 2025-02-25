//
//  NaxaLibreUiSettings.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation


/// A structure representing UI settings for NaxaLibre.
///
/// This structure holds various configuration options for customizing the appearance and behavior
/// of the map's UI elements, such as visibility, positioning, margins, and gesture controls.
struct NaxaLibreUiSettings {
    
    // MARK: - UI Element Visibility
    
    /// Determines whether the logo is visible on the map.
    let logoEnabled: Bool
    
    /// Determines whether the compass is visible on the map.
    let compassEnabled: Bool
    
    /// Determines whether the attribution button is visible on the map.
    let attributionEnabled: Bool
    
    // MARK: - UI Element Positioning
    
    /// Specifies the position of the attribution button (`"topLeft"`, `"topRight"`, `"bottomLeft"`, `"bottomRight"`).
    let attributionGravity: String?
    
    /// Specifies the position of the compass (`"topLeft"`, `"topRight"`, `"bottomLeft"`, `"bottomRight"`).
    let compassGravity: String?
    
    /// Specifies the position of the logo (`"topLeft"`, `"topRight"`, `"bottomLeft"`, `"bottomRight"`).
    let logoGravity: String?
    
    // MARK: - UI Element Margins
    
    /// Defines the margins for the logo view.
    let logoMargins: UIEdgeInsets?
    
    /// Defines the margins for the compass view.
    let compassMargins: UIEdgeInsets?
    
    /// Defines the margins for the attribution button.
    let attributionMargins: UIEdgeInsets?
    
    // MARK: - Gesture Controls
    
    /// Enables or disables rotation gestures.
    let rotateGesturesEnabled: Bool
    
    /// Enables or disables tilt gestures.
    let tiltGesturesEnabled: Bool
    
    /// Enables or disables zoom gestures.
    let zoomGesturesEnabled: Bool
    
    /// Enables or disables scroll gestures.
    let scrollGesturesEnabled: Bool
    
    /// Enables or disables horizontal scroll gestures.
    let horizontalScrollGesturesEnabled: Bool
    
    /// Enables or disables double-tap gestures for zooming.
    let doubleTapGesturesEnabled: Bool
    
    /// Enables or disables quick zoom gestures.
    let quickZoomGesturesEnabled: Bool
    
    // MARK: - Gesture Velocity & Threshold Settings
    
    /// Enables or disables animation scaling based on velocity during pinch-zoom.
    let scaleVelocityAnimationEnabled: Bool
    
    /// Enables or disables animation rotation based on velocity during rotate gestures.
    let rotateVelocityAnimationEnabled: Bool
    
    /// Enables or disables fling velocity animation.
    let flingVelocityAnimationEnabled: Bool
    
    /// Increases the rotation threshold when scaling.
    let increaseRotateThresholdWhenScaling: Bool
    
    /// Disables rotation when scaling is active.
    let disableRotateWhenScaling: Bool
    
    /// Increases the scaling threshold when rotating.
    let increaseScaleThresholdWhenRotating: Bool
    
    // MARK: - Additional Settings
    
    /// Fades the compass when the map is facing north.
    let fadeCompassWhenFacingNorth: Bool
    
    /// Sets the focal point for gestures.
    let focalPoint: CGPoint?
    
    /// Defines the fling threshold for the map gestures.
    let flingThreshold: Float?
    
    /// Defines the attribution settings for the map.
    let attributions: [String: Any?]?
    
    // MARK: - Parsing
    
    /// Parses a dictionary of settings into a `NaxaLibreUiSettings` instance.
    /// - Parameter args: A dictionary containing UI setting keys and values.
    /// - Returns: A `NaxaLibreUiSettings` instance populated with values from the dictionary.
    static func fromMap(_ args: [String: Any?]) -> NaxaLibreUiSettings {
        return NaxaLibreUiSettingsArgsParser.parseArgs(args)
    }
}

