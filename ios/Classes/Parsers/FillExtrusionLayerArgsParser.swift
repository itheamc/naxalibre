//
//  FillExtrusionLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre

struct FillExtrusionLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre fill extrusion layer.
    /// - Parameter args: A dictionary containing fill extrusion layer details.
    /// - Returns: A configured `MLNFillExtrusionStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource) -> MLNFillExtrusionStyleLayer? {
        guard let layerId = args["layerId"] as? String else {
            return nil
        }
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNFillExtrusionStyleLayer(identifier: layerId, source: source)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
        
        return layer
    }
}

/// Extension helper for the `MLNFillExtrusionStyleLayer`
///
fileprivate extension MLNFillExtrusionStyleLayer {
    
    // MARK: Configure Fill Extrusion Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNFillExtrusionStyleLayer {
        if let properties = properties {
            
            if let filter = properties["filter"] as? String, filter.hasPrefix("["), filter.hasSuffix("]") {
                do {
                    let data = filter.data(using: .utf8)!
                    let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    
                    self.predicate = NSPredicate(mglJSONObject: json)
                    
                } catch {
                    // Nothing to do
                }
            }
            
            if let sourceLayer = properties["source-layer"] as? String {
                self.sourceLayerIdentifier = sourceLayer
            }
            
            if let maxZoom = properties["maxzoom"] as? Double {
                self.maximumZoomLevel = Float(maxZoom)
            }
            
            if let minZoom = properties["minzoom"] as? Double {
                self.minimumZoomLevel = Float(minZoom)
            }
        }
        
        return self
    }
    
    // MARK: Method to configure fill extrusion layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNFillExtrusionStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let visibility = layoutProperties["visibility"] as? Bool {
                self.isVisible = visibility
            }
        }
        
        return self
    }
    
    // MARK: Method to configure fill extrusion layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNFillExtrusionStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let fillExtrusionColor = paintProperties["fill-extrusion-color"] {
                if let fillExtrusionColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillExtrusionColor, isColor: true) as NSExpression? {
                    self.fillExtrusionColor = fillExtrusionColorExpression
                }
            }
            
            if let fillExtrusionBase = paintProperties["fill-extrusion-base"] {
                if let fillExtrusionBaseExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillExtrusionBase) as NSExpression? {
                    self.fillExtrusionBase = fillExtrusionBaseExpression
                }
            }
            
            if let fillExtrusionHeight = paintProperties["fill-extrusion-height"] {
                if let fillExtrusionHeightExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillExtrusionHeight) as NSExpression? {
                    self.fillExtrusionHeight = fillExtrusionHeightExpression
                }
            }
            
            if let fillExtrusionOpacity = paintProperties["fill-extrusion-opacity"] {
                if let fillExtrusionOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillExtrusionOpacity) as NSExpression? {
                    self.fillExtrusionOpacity = fillExtrusionOpacityExpression
                }
            }
            
            if let fillExtrusionPattern = paintProperties["fill-extrusion-pattern"] {
                if let fillExtrusionPatternExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillExtrusionPattern) as NSExpression? {
                    self.fillExtrusionPattern = fillExtrusionPatternExpression
                }
            }
            
            if let fillExtrusionTranslate = paintProperties["fill-extrusion-translate"] as? [CGFloat], fillExtrusionTranslate.count == 2 {
                if let fillExtrusionTranslateExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillExtrusionTranslate) as NSExpression? {
                    self.fillExtrusionTranslation = fillExtrusionTranslateExpression
                }
            }
            
            if let fillExtrusionTranslateAnchor = paintProperties["fill-extrusion-translate-anchor"] as? String {
                self.fillExtrusionTranslationAnchor = expressionForFillExtrusionTranslateAnchor(fillExtrusionTranslateAnchor)
            }
            
            if let fillExtrusionVerticalGradient = paintProperties["fill-extrusion-vertical-gradient"] {
                if let fillExtrusionVerticalGradientExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillExtrusionVerticalGradient) as NSExpression? {
                    self.fillExtrusionHasVerticalGradient = fillExtrusionVerticalGradientExpression
                }
            }
        }
        
        return self
    }
    
    // MARK: Method to configure fill extrusion layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNFillExtrusionStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let fillExtrusionColorTransition = transitionProperties["fill-extrusion-color-transition"] as? [String: Any] {
                self.fillExtrusionColorTransition = transitionFromDictionary(fillExtrusionColorTransition)
            }
            
            if let fillExtrusionBaseTransition = transitionProperties["fill-extrusion-base-transition"] as? [String: Any] {
                self.fillExtrusionBaseTransition = transitionFromDictionary(fillExtrusionBaseTransition)
            }
            
            if let fillExtrusionHeightTransition = transitionProperties["fill-extrusion-height-transition"] as? [String: Any] {
                self.fillExtrusionHeightTransition = transitionFromDictionary(fillExtrusionHeightTransition)
            }
            
            if let fillExtrusionOpacityTransition = transitionProperties["fill-extrusion-opacity-transition"] as? [String: Any] {
                self.fillExtrusionOpacityTransition = transitionFromDictionary(fillExtrusionOpacityTransition)
            }
            
            if let fillExtrusionPatternTransition = transitionProperties["fill-extrusion-pattern-transition"] as? [String: Any] {
                self.fillExtrusionPatternTransition = transitionFromDictionary(fillExtrusionPatternTransition)
            }
            
            if let fillExtrusionTranslateTransition = transitionProperties["fill-extrusion-translate-transition"] as? [String: Any] {
                self.fillExtrusionTranslationTransition = transitionFromDictionary(fillExtrusionTranslateTransition)
            }
        }
        
        return self
    }
    
    // MARK: Helper Methods for Enum-Based Properties
    private func expressionForFillExtrusionTranslateAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNFillExtrusionTranslationAnchor
            
            switch anchor.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .map // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnFillExtrusionTranslationAnchor: value))
        }
    }
    
    // MARK: Transition creation helper
    private func transitionFromDictionary(_ dict: [String: Any]) -> MLNTransition {
        let duration = dict["duration"] as? TimeInterval ?? 0
        let delay = dict["delay"] as? TimeInterval ?? 0
        
        return MLNTransition(duration: duration, delay: delay)
    }
}
