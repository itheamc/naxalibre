//
//  BackgroundLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre

struct BackgroundLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre background layer.
    /// - Parameter args: A dictionary containing background layer details.
    /// - Returns: A configured `MLNBackgroundStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?]) -> MLNBackgroundStyleLayer? {
        guard let layerId = args["layerId"] as? String else {
            return nil
        }
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNBackgroundStyleLayer(identifier: layerId)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
        
        return layer
    }
}

/// Extension helper for the `MLNBackgroundStyleLayer`
///
fileprivate extension MLNBackgroundStyleLayer {
    
    // MARK: Configure Background Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNBackgroundStyleLayer {
        if let properties = properties {
            
            if let maxZoom = properties["maxzoom"] as? Double {
                self.maximumZoomLevel = Float(maxZoom)
            }
            
            if let minZoom = properties["minzoom"] as? Double {
                self.minimumZoomLevel = Float(minZoom)
            }
        }
        
        return self
    }
    
    // MARK: Method to configure background layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNBackgroundStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let visibility = layoutProperties["visibility"] as? String {
                self.isVisible = visibility == "visible"
            }
        }
        
        return self
    }
    
    // MARK: Method to configure background layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNBackgroundStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let backgroundColor = paintProperties["background-color"] {
                if let backgroundColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(backgroundColor, isColor: true) as NSExpression? {
                    self.backgroundColor = backgroundColorExpression
                }
            }
            
            if let backgroundOpacity = paintProperties["background-opacity"] {
                if let backgroundOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(backgroundOpacity) as NSExpression? {
                    self.backgroundOpacity = backgroundOpacityExpression
                }
            }
            
            if let backgroundPattern = paintProperties["background-pattern"] {
                if let backgroundPatternExpression = NaxaLibreExpressionsUtils.expressionFromValue(backgroundPattern) as NSExpression? {
                    self.backgroundPattern = backgroundPatternExpression
                }
            }
        }
        
        return self
    }
    
    // MARK: Method to configure background layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNBackgroundStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let backgroundColorTransition = transitionProperties["background-color-transition"] as? [String: Any] {
                self.backgroundColorTransition = transitionFromDictionary(backgroundColorTransition)
            }
            
            if let backgroundOpacityTransition = transitionProperties["background-opacity-transition"] as? [String: Any] {
                self.backgroundOpacityTransition = transitionFromDictionary(backgroundOpacityTransition)
            }
            
            if let backgroundPatternTransition = transitionProperties["background-pattern-transition"] as? [String: Any] {
                self.backgroundPatternTransition = transitionFromDictionary(backgroundPatternTransition)
            }
        }
        
        return self
    }
    
    // MARK: Transition creation helper
    private func transitionFromDictionary(_ dict: [String: Any]) -> MLNTransition {
        let duration = dict["duration"] as? TimeInterval ?? 0
        let delay = dict["delay"] as? TimeInterval ?? 0
        
        return MLNTransition(duration: duration / 1000, delay: delay / 1000)
    }
}
