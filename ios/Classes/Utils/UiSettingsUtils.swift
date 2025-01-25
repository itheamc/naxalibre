//
//  UiSettingsUtils.swift
//  Pods
//
//  Created by Amit on 25/01/2025.
//

import Foundation

struct UiSettingsUtils {
    struct NaxaLibreUiSettings {
        let logoEnabled: Bool
        let compassEnabled: Bool
        let attributionEnabled: Bool
        let attributionGravity: Int?
        let compassGravity: Int?
        let logoGravity: Int?
        let logoMargins: [Double]?
        let compassMargins: [Double]?
        let attributionMargins: [Double]?
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
        let compassImage: String?

        static func fromMap(_ map: [String: Any?]) -> NaxaLibreUiSettings {
            return UiSettingsUtils.parseUiSettings(map)
        }
    }

    static func parseUiSettings(_ map: [String: Any?]) -> NaxaLibreUiSettings {
        return NaxaLibreUiSettings(
            logoEnabled: map["logoEnabled"] as? Bool ?? false,
            compassEnabled: map["compassEnabled"] as? Bool ?? false,
            attributionEnabled: map["attributionEnabled"] as? Bool ?? false,
            attributionGravity: map["attributionGravity"] as? Int,
            compassGravity: map["compassGravity"] as? Int,
            logoGravity: map["logoGravity"] as? Int,
            logoMargins: parseMargins(map["logoMargins"]),
            compassMargins: parseMargins(map["compassMargins"]),
            attributionMargins: parseMargins(map["attributionMargins"]),
            rotateGesturesEnabled: map["rotateGesturesEnabled"] as? Bool ?? false,
            tiltGesturesEnabled: map["tiltGesturesEnabled"] as? Bool ?? false,
            zoomGesturesEnabled: map["zoomGesturesEnabled"] as? Bool ?? false,
            scrollGesturesEnabled: map["scrollGesturesEnabled"] as? Bool ?? false,
            horizontalScrollGesturesEnabled: map["horizontalScrollGesturesEnabled"] as? Bool ?? false,
            doubleTapGesturesEnabled: map["doubleTapGesturesEnabled"] as? Bool ?? false,
            quickZoomGesturesEnabled: map["quickZoomGesturesEnabled"] as? Bool ?? false,
            scaleVelocityAnimationEnabled: map["scaleVelocityAnimationEnabled"] as? Bool ?? false,
            rotateVelocityAnimationEnabled: map["rotateVelocityAnimationEnabled"] as? Bool ?? false,
            flingVelocityAnimationEnabled: map["flingVelocityAnimationEnabled"] as? Bool ?? false,
            increaseRotateThresholdWhenScaling: map["increaseRotateThresholdWhenScaling"] as? Bool ?? false,
            disableRotateWhenScaling: map["disableRotateWhenScaling"] as? Bool ?? false,
            increaseScaleThresholdWhenRotating: map["increaseScaleThresholdWhenRotating"] as? Bool ?? false,
            fadeCompassWhenFacingNorth: map["fadeCompassWhenFacingNorth"] as? Bool ?? false,
            focalPoint: parseFocalPoint(map["focalPoint"]),
            flingThreshold: map["flingThreshold"] as? Float,
            compassImage: map["compassImage"] as? String
        )
    }

    private static func parseMargins(_ margins: Any??) -> [Double]? {
        guard let marginList = margins as? [Any], marginList.count == 4 else { return nil }
        return marginList.map { ($0 as? NSNumber)?.doubleValue ?? 0.0 }
    }

    private static func parseFocalPoint(_ focalPoint: Any??) -> CGPoint? {
        guard let pointList = focalPoint as? [Any], pointList.count == 2 else { return nil }
        return CGPoint(
            x: CGFloat((pointList[0] as? NSNumber)?.floatValue ?? 0.0),
            y: CGFloat((pointList[1] as? NSNumber)?.floatValue ?? 0.0)
        )
    }
}
