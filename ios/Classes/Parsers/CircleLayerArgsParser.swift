//
//  CircleLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 24/02/2025.
//

import Foundation
import MapLibre

struct CircleLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre circle layer.
    /// - Parameter args: A dictionary containing circle  layer details.
    /// - Returns: A configured `MLNCircleStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource) -> MLNCircleStyleLayer? {
        let layerId = args["layerId"] as! String
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNCircleStyleLayer(identifier: layerId, source: source)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
        
        return layer
    }
}


/// Extension helper for the `MLNCircleStyleLayer`
///
extension MLNCircleStyleLayer {
    
    // MARK: Configure Symbol Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNCircleStyleLayer {
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
    
    // MARK: Method to configure circle layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNCircleStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let sortKey = layoutProperties["circle-sort-key"] {
                if let sortKeyExpression = NaxaLibreExpressionsUtils.expressionFromValue(sortKey) as NSExpression? {
                    self.circleSortKey = sortKeyExpression
                }
            }
            
            if let visibility = layoutProperties["visibility"] as? Bool {
                self.isVisible = visibility
            }
        }
        
        return self
    }
    
    // MARK: Method to configure circle layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNCircleStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let blur = paintProperties["circle-blur"] {
                if let blurExpression = NaxaLibreExpressionsUtils.expressionFromValue(blur) as NSExpression? {
                    self.circleBlur = blurExpression
                }
            }
            
            if let color = paintProperties["circle-color"] {
                if let colorExpression = NaxaLibreExpressionsUtils.expressionFromValue(color, isColor: true) as NSExpression? {
                    self.circleColor = colorExpression
                }
            }
            
            if let opacity = paintProperties["circle-opacity"] {
                if let opacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(opacity) as NSExpression? {
                    self.circleOpacity = opacityExpression
                }
            }
            
            if let pitchAlignment = paintProperties["circle-pitch-alignment"] as? String {
                if let pitchAlignmentExpression = NaxaLibreExpressionsUtils.expressionFromValue(pitchAlignment) as NSExpression? {
                    self.circlePitchAlignment = pitchAlignmentExpression
                }
            }
            
            if let radius = paintProperties["circle-radius"] {
                if let radiusExpression = NaxaLibreExpressionsUtils.expressionFromValue(radius) as NSExpression? {
                    self.circleRadius = radiusExpression
                }
            }
            
            if let scaleAlignment = paintProperties["circle-scale-alignment"] as? String {
                if let scaleAlignmentExpression = NaxaLibreExpressionsUtils.expressionFromValue(scaleAlignment) as NSExpression? {
                    self.circleScaleAlignment = scaleAlignmentExpression
                }
            }
            
            if let strokeColor = paintProperties["circle-stroke-color"] {
                if let strokeColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(strokeColor, isColor: true) as NSExpression? {
                    self.circleStrokeColor = strokeColorExpression
                }
            }
            
            if let strokeOpacity = paintProperties["circle-stroke-opacity"] {
                if let strokeOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(strokeOpacity) as NSExpression? {
                    self.circleStrokeOpacity = strokeOpacityExpression
                }
            }
            
            if let strokeWidth = paintProperties["circle-stroke-width"] {
                if let strokeWidthExpression = NaxaLibreExpressionsUtils.expressionFromValue(strokeWidth) as NSExpression? {
                    self.circleStrokeWidth = strokeWidthExpression
                }
            }
            
            if let translation = paintProperties["circle-translation"] as? [CGFloat], translation.count == 2 {
                if let translationExpression = NaxaLibreExpressionsUtils.expressionFromValue(translation) as NSExpression? {
                    self.circleTranslation = translationExpression
                }
            }
            
            if let translationAnchor = paintProperties["circle-translation-anchor"] as? String {
                if let translationAnchorExpression = NaxaLibreExpressionsUtils.expressionFromValue(translationAnchor) as NSExpression? {
                    self.circleTranslationAnchor = translationAnchorExpression
                }
            }
        }
        
        return self
    }
    
    // MARK: Method to configure circle layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNCircleStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let blurTransition = transitionProperties["circle-blur-transition"] as? [String: Any] {
                self.circleBlurTransition = transitionFromDictionary(blurTransition)
            }
            
            if let colorTransition = transitionProperties["circle-color-transition"] as? [String: Any] {
                self.circleColorTransition = transitionFromDictionary(colorTransition)
            }
            
            if let opacityTransition = transitionProperties["circle-opacity-transition"] as? [String: Any] {
                self.circleOpacityTransition = transitionFromDictionary(opacityTransition)
            }
            
            if let radiusTransition = transitionProperties["circle-radius-transition"] as? [String: Any] {
                self.circleRadiusTransition = transitionFromDictionary(radiusTransition)
            }
            
            if let strokeColorTransition = transitionProperties["circle-stroke-color-transition"] as? [String: Any] {
                self.circleStrokeColorTransition = transitionFromDictionary(strokeColorTransition)
            }
            
            if let strokeOpacityTransition = transitionProperties["circle-stroke-opacity-transition"] as? [String: Any] {
                self.circleStrokeOpacityTransition = transitionFromDictionary(strokeOpacityTransition)
            }
            
            if let strokeWidthTransition = transitionProperties["circle-stroke-width-transition"] as? [String: Any] {
                self.circleStrokeWidthTransition = transitionFromDictionary(strokeWidthTransition)
            }
            
            if let translationTransition = transitionProperties["circle-translation-transition"] as? [String: Any] {
                self.circleTranslationTransition = transitionFromDictionary(translationTransition)
            }
        }
        
        return self
    }
    
    // MARK: Helper Methods for Enum-Based Properties
    private func expressionForCirclePitchAlignment(_ alignment: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(alignment) {
            return expression
        } else {
            let value: MLNCirclePitchAlignment
            
            switch alignment {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .viewport // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnCirclePitchAlignment: value))
        }
    }
    
    private func expressionForCircleScaleAlignment(_ alignment: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(alignment) {
            return expression
        } else {
            let value: MLNCircleScaleAlignment
            
            switch alignment {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .map // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnCircleScaleAlignment: value))
        }
    }
    
    private func expressionForCircleTranslationAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNCircleTranslationAnchor
            
            switch anchor {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .map // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnCircleTranslationAnchor: value))
        }
    }
    
    // MARK: Transition creation helper
    private func transitionFromDictionary(_ dict: [String: Any]) -> MLNTransition {
        let duration = dict["duration"] as? TimeInterval ?? 0
        let delay = dict["delay"] as? TimeInterval ?? 0
        
        return MLNTransition(duration: duration / 1000, delay: delay / 1000)
    }
}
