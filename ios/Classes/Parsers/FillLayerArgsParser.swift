//
//  FillLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre

struct FillLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre fill layer.
    /// - Parameter args: A dictionary containing fill layer details.
    /// - Returns: A configured `MLNFillStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource) -> MLNFillStyleLayer? {
        guard let layerId = args["layerId"] as? String else {
            return nil
        }
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNFillStyleLayer(identifier: layerId, source: source)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
        
        return layer
    }
}

/// Extension helper for the `MLNFillStyleLayer`
///
extension MLNFillStyleLayer {
    
    // MARK: Configure Fill Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNFillStyleLayer {
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
    
    // MARK: Method to configure fill layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNFillStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let fillSortKey = layoutProperties["fill-sort-key"] {
                if let fillSortKeyExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillSortKey) as NSExpression? {
                    self.fillSortKey = fillSortKeyExpression
                }
            }
            
            if let visibility = layoutProperties["visibility"] as? String {
                self.isVisible = visibility == "visible"
            }
        }
        
        return self
    }
    
    // MARK: Method to configure fill layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNFillStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let fillColor = paintProperties["fill-color"] {
                if let fillColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillColor, isColor: true) as NSExpression? {
                    self.fillColor = fillColorExpression
                }
            }
            
            if let fillAntialias = paintProperties["fill-antialias"] {
                if let fillAntialiasExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillAntialias) as NSExpression? {
                    self.fillAntialiased = fillAntialiasExpression
                }
            }
            
            if let fillOpacity = paintProperties["fill-opacity"] {
                if let fillOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillOpacity) as NSExpression? {
                    self.fillOpacity = fillOpacityExpression
                }
            }
            
            if let fillOutlineColor = paintProperties["fill-outline-color"] {
                if let fillOutlineColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillOutlineColor, isColor: true) as NSExpression? {
                    self.fillOutlineColor = fillOutlineColorExpression
                }
            }
            
            if let fillPattern = paintProperties["fill-pattern"] {
                if let fillPatternExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillPattern) as NSExpression? {
                    self.fillPattern = fillPatternExpression
                }
            }
            
            if let fillTranslate = paintProperties["fill-translate"] as? [CGFloat], fillTranslate.count == 2 {
                if let fillTranslateExpression = NaxaLibreExpressionsUtils.expressionFromValue(fillTranslate) as NSExpression? {
                    self.fillTranslation = fillTranslateExpression
                }
            }
            
            if let fillTranslateAnchor = paintProperties["fill-translate-anchor"] as? String {
                self.fillTranslationAnchor = expressionForFillTranslateAnchor(fillTranslateAnchor)
            }
        }
        
        return self
    }
    
    // MARK: Method to configure fill layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNFillStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let fillColorTransition = transitionProperties["fill-color-transition"] as? [String: Any] {
                self.fillColorTransition = transitionFromDictionary(fillColorTransition)
            }
            
            if let fillOpacityTransition = transitionProperties["fill-opacity-transition"] as? [String: Any] {
                self.fillOpacityTransition = transitionFromDictionary(fillOpacityTransition)
            }
            
            if let fillOutlineColorTransition = transitionProperties["fill-outline-color-transition"] as? [String: Any] {
                self.fillOutlineColorTransition = transitionFromDictionary(fillOutlineColorTransition)
            }
            
            if let fillPatternTransition = transitionProperties["fill-pattern-transition"] as? [String: Any] {
                self.fillPatternTransition = transitionFromDictionary(fillPatternTransition)
            }
            
            if let fillTranslateTransition = transitionProperties["fill-translate-transition"] as? [String: Any] {
                self.fillTranslationTransition = transitionFromDictionary(fillTranslateTransition)
            }
        }
        
        return self
    }
    
    // MARK: Helper Methods for Enum-Based Properties
    private func expressionForFillTranslateAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNFillTranslationAnchor
            
            switch anchor.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .map // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnFillTranslationAnchor: value))
        }
    }
    
    // MARK: Transition creation helper
    private func transitionFromDictionary(_ dict: [String: Any]) -> MLNTransition {
        let duration = dict["duration"] as? TimeInterval ?? 0
        let delay = dict["delay"] as? TimeInterval ?? 0
        
        return MLNTransition(duration: duration / 1000, delay: delay / 1000)
    }
}
