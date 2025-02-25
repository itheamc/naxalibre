//
//  NaxaLibreUiSettingsArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation

/// A parser for handling UI settings related to NaxaLibre.
struct NaxaLibreUiSettingsArgsParser {
    
    /// Represents UI settings for NaxaLibre.
    struct NaxaLibreUiSettings {
        let logoEnabled: Bool
        let compassEnabled: Bool
        let attributionEnabled: Bool
        let attributionGravity: String?
        let compassGravity: String?
        let logoGravity: String?
        let logoMargins: UIEdgeInsets?
        let compassMargins: UIEdgeInsets?
        let attributionMargins: UIEdgeInsets?
        let rotateGesturesEnabled: Bool
        let tiltGesturesEnabled: Bool
        let zoomGesturesEnabled: Bool
        let scrollGesturesEnabled: Bool
        let horizontalScrollGesturesEnabled: Bool
        let doubleTapGesturesEnabled: Bool
        let quickZoomGesturesEnabled: Bool
        let scaleVelocityAnimationEnabled: Bool
        let rotateVelocityAnimationEnabled: Bool
        let flingVelocityAnimationEnabled: Bool
        let increaseRotateThresholdWhenScaling: Bool
        let disableRotateWhenScaling: Bool
        let increaseScaleThresholdWhenRotating: Bool
        let fadeCompassWhenFacingNorth: Bool
        let focalPoint: CGPoint?
        let flingThreshold: Float?
        let attributions: [String: Any?]?
        
        /// Parses a dictionary of settings into a `NaxaLibreUiSettings` instance.
        /// - Parameter args: A dictionary containing UI setting keys and values.
        /// - Returns: A `NaxaLibreUiSettings` instance populated with values from the map.
        ///
        static func fromMap(_ args: [String: Any?]) -> NaxaLibreUiSettings {
            return NaxaLibreUiSettingsArgsParser.parseArgs(args)
        }
    }
    
    /// Parses a dictionary of UI settings into a `NaxaLibreUiSettings` instance.
    /// - Parameter args: A dictionary containing UI setting keys and values.
    /// - Returns: A `NaxaLibreUiSettings` instance with the parsed values.
    ///
    static func parseArgs(_ args: [String: Any?]) -> NaxaLibreUiSettings {
        return NaxaLibreUiSettings(
            logoEnabled: args["logoEnabled"] as? Bool ?? true,
            compassEnabled: args["compassEnabled"] as? Bool ?? true,
            attributionEnabled: args["attributionEnabled"] as? Bool ?? true,
            attributionGravity: args["attributionGravity"] as? String,
            compassGravity: args["compassGravity"] as? String,
            logoGravity: args["logoGravity"] as? String,
            logoMargins: parseMargins(args["logoMargins"]),
            compassMargins: parseMargins(args["compassMargins"]),
            attributionMargins: parseMargins(args["attributionMargins"]),
            rotateGesturesEnabled: args["rotateGesturesEnabled"] as? Bool ?? true,
            tiltGesturesEnabled: args["tiltGesturesEnabled"] as? Bool ?? true,
            zoomGesturesEnabled: args["zoomGesturesEnabled"] as? Bool ?? true,
            scrollGesturesEnabled: args["scrollGesturesEnabled"] as? Bool ?? true,
            horizontalScrollGesturesEnabled: args["horizontalScrollGesturesEnabled"] as? Bool ?? true,
            doubleTapGesturesEnabled: args["doubleTapGesturesEnabled"] as? Bool ?? true,
            quickZoomGesturesEnabled: args["quickZoomGesturesEnabled"] as? Bool ?? true,
            scaleVelocityAnimationEnabled: args["scaleVelocityAnimationEnabled"] as? Bool ?? true,
            rotateVelocityAnimationEnabled: args["rotateVelocityAnimationEnabled"] as? Bool ?? true,
            flingVelocityAnimationEnabled: args["flingVelocityAnimationEnabled"] as? Bool ?? true,
            increaseRotateThresholdWhenScaling: args["increaseRotateThresholdWhenScaling"] as? Bool ?? true,
            disableRotateWhenScaling: args["disableRotateWhenScaling"] as? Bool ?? true,
            increaseScaleThresholdWhenRotating: args["increaseScaleThresholdWhenRotating"] as? Bool ?? true,
            fadeCompassWhenFacingNorth: args["fadeCompassWhenFacingNorth"] as? Bool ?? true,
            focalPoint: parseFocalPoint(args["focalPoint"]),
            flingThreshold: args["flingThreshold"] as? Float,
            attributions: args["attributions"] as? [String: Any?]
        )
    }
    
    /// Parses margin values from an array to `UIEdgeInsets`.
    /// - Parameter margins: An optional value containing an array of four margins.
    /// - Returns: A `UIEdgeInsets` instance if parsing succeeds; otherwise, `nil`.
    ///
    private static func parseMargins(_ margins: Any??) -> UIEdgeInsets? {
        guard let marginList = margins as? [Any], marginList.count == 4 else { return nil }
        let formatted = marginList.map { ($0 as? NSNumber)?.floatValue ?? 0.0 }
        
        return UIEdgeInsets(
            top: CGFloat(formatted[1]),
            left: CGFloat(formatted[0]),
            bottom: CGFloat(formatted[3]),
            right: CGFloat(formatted[2])
        )
        
    }
    
    /// Parses a focal point from an array into a `CGPoint`.
    /// - Parameter focalPoint: An optional value containing an array with x and y coordinates.
    /// - Returns: A `CGPoint` instance if parsing succeeds; otherwise, `nil`.
    ///
    private static func parseFocalPoint(_ focalPoint: Any??) -> CGPoint? {
        guard let pointList = focalPoint as? [Any], pointList.count == 2 else { return nil }
        return CGPoint(
            x: CGFloat((pointList[0] as? NSNumber)?.floatValue ?? 0.0),
            y: CGFloat((pointList[1] as? NSNumber)?.floatValue ?? 0.0)
        )
    }
}
