//
//  HillShadeLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre

struct HillShadeLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre hillshade layer.
    /// - Parameter args: A dictionary containing hillshade layer details.
    /// - Returns: A configured `MLNHillshadeStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource) -> MLNHillshadeStyleLayer? {
        guard let layerId = args["layerId"] as? String else {
            return nil
        }
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNHillshadeStyleLayer(identifier: layerId, source: source)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
        
        return layer
    }
}

/// Extension helper for the `MLNHillshadeStyleLayer`
///
fileprivate extension MLNHillshadeStyleLayer {
    
    // MARK: Configure HillShade Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNHillshadeStyleLayer {
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
    
    // MARK: Method to configure hillshade layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNHillshadeStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let visibility = layoutProperties["visibility"] as? String {
                self.isVisible = visibility == "visible"
            }
        }
        
        return self
    }
    
    // MARK: Method to configure hillshade layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNHillshadeStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let hillShadeAccentColor = paintProperties["hill-shade-accent-color"] {
                if let hillShadeAccentColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(hillShadeAccentColor, isColor: true) as NSExpression? {
                    self.hillshadeAccentColor = hillShadeAccentColorExpression
                }
            }
            
            if let hillShadeExaggeration = paintProperties["hill-shade-exaggeration"] {
                if let hillShadeExaggerationExpression = NaxaLibreExpressionsUtils.expressionFromValue(hillShadeExaggeration) as NSExpression? {
                    self.hillshadeExaggeration = hillShadeExaggerationExpression
                }
            }
            
            if let hillShadeHighlightColor = paintProperties["hill-shade-highlight-color"] {
                if let hillShadeHighlightColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(hillShadeHighlightColor, isColor: true) as NSExpression? {
                    self.hillshadeHighlightColor = hillShadeHighlightColorExpression
                }
            }
            
            if let hillShadeIlluminationAnchor = paintProperties["hill-shade-illumination-anchor"] as? String {
                self.hillshadeIlluminationAnchor = expressionForHillShadeIlluminationAnchor(hillShadeIlluminationAnchor)
            }
            
            if let hillShadeIlluminationDirection = paintProperties["hill-shade-illumination-direction"] {
                if let hillShadeIlluminationDirectionExpression = NaxaLibreExpressionsUtils.expressionFromValue(hillShadeIlluminationDirection) as NSExpression? {
                    self.hillshadeIlluminationDirection = hillShadeIlluminationDirectionExpression
                }
            }
            
            if let hillShadeShadowColor = paintProperties["hill-shade-shadow-color"] {
                if let hillShadeShadowColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(hillShadeShadowColor, isColor: true) as NSExpression? {
                    self.hillshadeShadowColor = hillShadeShadowColorExpression
                }
            }
        }
        
        return self
    }
    
    // MARK: Method to configure hillshade layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNHillshadeStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let hillShadeAccentColorTransition = transitionProperties["hill-shade-accent-color-transition"] as? [String: Any] {
                self.hillshadeAccentColorTransition = transitionFromDictionary(hillShadeAccentColorTransition)
            }
            
            if let hillShadeExaggerationTransition = transitionProperties["hill-shade-exaggeration-transition"] as? [String: Any] {
                self.hillshadeExaggerationTransition = transitionFromDictionary(hillShadeExaggerationTransition)
            }
            
            if let hillShadeHighlightColorTransition = transitionProperties["hill-shade-highlight-color-transition"] as? [String: Any] {
                self.hillshadeHighlightColorTransition = transitionFromDictionary(hillShadeHighlightColorTransition)
            }
            
            if let hillShadeShadowColorTransition = transitionProperties["hill-shade-shadow-color-transition"] as? [String: Any] {
                self.hillshadeShadowColorTransition = transitionFromDictionary(hillShadeShadowColorTransition)
            }
        }
        
        return self
    }
    
    // MARK: Helper Methods for Enum-Based Properties
    private func expressionForHillShadeIlluminationAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNHillshadeIlluminationAnchor
            
            switch anchor.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .viewport // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnHillshadeIlluminationAnchor: value))
        }
    }
    
    // MARK: Transition creation helper
    private func transitionFromDictionary(_ dict: [String: Any]) -> MLNTransition {
        let duration = dict["duration"] as? TimeInterval ?? 0
        let delay = dict["delay"] as? TimeInterval ?? 0
        
        return MLNTransition(duration: duration / 1000, delay: delay / 1000)
    }
}
