//
//  HeatmapLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre

struct HeatmapLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre heatmap layer.
    /// - Parameter args: A dictionary containing heatmap layer details.
    /// - Returns: A configured `MLNHeatmapStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource) -> MLNHeatmapStyleLayer? {
        guard let layerId = args["layerId"] as? String else {
            return nil
        }
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNHeatmapStyleLayer(identifier: layerId, source: source)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
        
        return layer
    }
}

/// Extension helper for the `MLNHeatmapStyleLayer`
///
fileprivate extension MLNHeatmapStyleLayer {
    
    // MARK: Configure Heatmap Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNHeatmapStyleLayer {
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
    
    // MARK: Method to configure heatmap layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNHeatmapStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let visibility = layoutProperties["visibility"] as? String {
                self.isVisible = visibility == "visible"
            }
        }
        
        return self
    }
    
    // MARK: Method to configure heatmap layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNHeatmapStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let heatmapColor = paintProperties["heatmap-color"] {
                if let heatmapColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(heatmapColor, isColor: true) as NSExpression? {
                    self.heatmapColor = heatmapColorExpression
                }
            }
            
            if let heatmapIntensity = paintProperties["heatmap-intensity"] {
                if let heatmapIntensityExpression = NaxaLibreExpressionsUtils.expressionFromValue(heatmapIntensity) as NSExpression? {
                    self.heatmapIntensity = heatmapIntensityExpression
                }
            }
            
            if let heatmapOpacity = paintProperties["heatmap-opacity"] {
                if let heatmapOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(heatmapOpacity) as NSExpression? {
                    self.heatmapOpacity = heatmapOpacityExpression
                }
            }
            
            if let heatmapRadius = paintProperties["heatmap-radius"] {
                if let heatmapRadiusExpression = NaxaLibreExpressionsUtils.expressionFromValue(heatmapRadius) as NSExpression? {
                    self.heatmapRadius = heatmapRadiusExpression
                }
            }
            
            if let heatmapWeight = paintProperties["heatmap-weight"] {
                if let heatmapWeightExpression = NaxaLibreExpressionsUtils.expressionFromValue(heatmapWeight) as NSExpression? {
                    self.heatmapWeight = heatmapWeightExpression
                }
            }
        }
        
        return self
    }
    
    // MARK: Method to configure heatmap layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNHeatmapStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let heatmapIntensityTransition = transitionProperties["heatmap-intensity-transition"] as? [String: Any] {
                self.heatmapIntensityTransition = transitionFromDictionary(heatmapIntensityTransition)
            }
            
            if let heatmapOpacityTransition = transitionProperties["heatmap-opacity-transition"] as? [String: Any] {
                self.heatmapOpacityTransition = transitionFromDictionary(heatmapOpacityTransition)
            }
            
            if let heatmapRadiusTransition = transitionProperties["heatmap-radius-transition"] as? [String: Any] {
                self.heatmapRadiusTransition = transitionFromDictionary(heatmapRadiusTransition)
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
