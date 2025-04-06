//
//  LineLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre

struct LineLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre line layer.
    /// - Parameter args: A dictionary containing line layer details.
    /// - Returns: A configured `MLNLineStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource) -> MLNLineStyleLayer? {
        guard let layerId = args["layerId"] as? String else {
            return nil
        }
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNLineStyleLayer(identifier: layerId, source: source)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
      
        return layer
    }
}


/// Extension helper for the `MLNLineStyleLayer`
///
extension MLNLineStyleLayer {
    
    // MARK: Configure Line Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNLineStyleLayer {
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
    
    // MARK: Method to configure line layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNLineStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let lineCap = layoutProperties["line-cap"] as? String {
                self.lineCap = expressionForLineCap(lineCap)
            }
            
            if let lineJoin = layoutProperties["line-join"] as? String {
                self.lineJoin = expressionForLineJoin(lineJoin)
            }
            
            if let lineMiterLimit = layoutProperties["line-miter-limit"] {
                if let lineMiterLimitExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineMiterLimit) as NSExpression? {
                    self.lineMiterLimit = lineMiterLimitExpression
                }
            }
            
            if let lineRoundLimit = layoutProperties["line-round-limit"] {
                if let lineRoundLimitExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineRoundLimit) as NSExpression? {
                    self.lineRoundLimit = lineRoundLimitExpression
                }
            }
            
            if let lineSortKey = layoutProperties["line-sort-key"] {
                if let lineSortKeyExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineSortKey) as NSExpression? {
                    self.lineSortKey = lineSortKeyExpression
                }
            }
            
            if let visibility = layoutProperties["visibility"] as? Bool {
                self.isVisible = visibility
            }
        }
        
        return self
    }
    
    // MARK: Method to configure line layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNLineStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let lineWidth = paintProperties["line-width"] {
                if let lineWidthExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineWidth) as NSExpression? {
                    self.lineWidth = lineWidthExpression
                }
            }
            
            if let lineColor = paintProperties["line-color"] {
                if let lineColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineColor, isColor: true) as NSExpression? {
                    self.lineColor = lineColorExpression
                }
            }
            
            if let lineBlur = paintProperties["line-blur"] {
                if let lineBlurExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineBlur) as NSExpression? {
                    self.lineBlur = lineBlurExpression
                }
            }
            
            if let lineDashArray = paintProperties["line-dasharray"] {
                if let lineDashArrayExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineDashArray) as NSExpression? {
                    self.lineDashPattern = lineDashArrayExpression
                }
            }
            
            if let lineGapWidth = paintProperties["line-gap-width"] {
                if let lineGapWidthExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineGapWidth) as NSExpression? {
                    self.lineGapWidth = lineGapWidthExpression
                }
            }
            
            if let lineGradient = paintProperties["line-gradient"] {
                if let lineGradientExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineGradient) as NSExpression? {
                    self.lineGradient = lineGradientExpression
                }
            }
            
            if let lineOffset = paintProperties["line-offset"] {
                if let lineOffsetExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineOffset) as NSExpression? {
                    self.lineOffset = lineOffsetExpression
                }
            }
            
            if let lineOpacity = paintProperties["line-opacity"] {
                if let lineOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineOpacity) as NSExpression? {
                    self.lineOpacity = lineOpacityExpression
                }
            }
            
            if let linePattern = paintProperties["line-pattern"] {
                if let linePatternExpression = NaxaLibreExpressionsUtils.expressionFromValue(linePattern) as NSExpression? {
                    self.linePattern = linePatternExpression
                }
            }
            
            if let lineTranslate = paintProperties["line-translate"] as? [CGFloat], lineTranslate.count == 2 {
                if let lineTranslateExpression = NaxaLibreExpressionsUtils.expressionFromValue(lineTranslate) as NSExpression? {
                    self.lineTranslation = lineTranslateExpression
                }
            }
            
            if let lineTranslateAnchor = paintProperties["line-translate-anchor"] as? String {
                self.lineTranslationAnchor = expressionForLineTranslateAnchor(lineTranslateAnchor)
            }
            
            if let lineTrimOffset = paintProperties["line-trim-offset"] as? [CGFloat], lineTrimOffset.count == 2 {
                if (NaxaLibreExpressionsUtils.expressionFromValue(lineTrimOffset) as NSExpression?) != nil {
                    // Don't have in ios maplibre
                 }
            }
        }
        
        return self
    }
    
    // MARK: Method to configure line layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNLineStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let lineWidthTransition = transitionProperties["line-width-transition"] as? [String: Any] {
                self.lineWidthTransition = transitionFromDictionary(lineWidthTransition)
            }
            
            if let lineColorTransition = transitionProperties["line-color-transition"] as? [String: Any] {
                self.lineColorTransition = transitionFromDictionary(lineColorTransition)
            }
            
            if let lineBlurTransition = transitionProperties["line-blur-transition"] as? [String: Any] {
                self.lineBlurTransition = transitionFromDictionary(lineBlurTransition)
            }
            
            if let lineDashArrayTransition = transitionProperties["line-dash-array-transition"] as? [String: Any] {
                self.lineDashPatternTransition = transitionFromDictionary(lineDashArrayTransition)
            }
            
            if let lineGapWidthTransition = transitionProperties["line-gap-width-transition"] as? [String: Any] {
                self.lineGapWidthTransition = transitionFromDictionary(lineGapWidthTransition)
            }
            
            if let lineOffsetTransition = transitionProperties["line-offset-transition"] as? [String: Any] {
                self.lineOffsetTransition = transitionFromDictionary(lineOffsetTransition)
            }
            
            if let lineOpacityTransition = transitionProperties["line-opacity-transition"] as? [String: Any] {
                self.lineOpacityTransition = transitionFromDictionary(lineOpacityTransition)
            }
            
            if let linePatternTransition = transitionProperties["line-pattern-transition"] as? [String: Any] {
                self.linePatternTransition = transitionFromDictionary(linePatternTransition)
            }
            
            if let lineTranslateTransition = transitionProperties["line-translate-transition"] as? [String: Any] {
                self.lineTranslationTransition = transitionFromDictionary(lineTranslateTransition)
            }
        }
        
        return self
    }
    
    // MARK: Helper Methods for Enum-Based Properties
    private func expressionForLineCap(_ cap: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(cap) {
            return expression
        } else {
            let value: MLNLineCap
            
            switch cap.lowercased() {
                case "butt":
                    value = .butt
                case "round":
                    value = .round
                case "square":
                    value = .square
                default:
                    value = .butt // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnLineCap: value))
        }
    }
    
    private func expressionForLineJoin(_ join: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(join) {
            return expression
        } else {
            let value: MLNLineJoin
            
            switch join.lowercased() {
                case "bevel":
                    value = .bevel
                case "round":
                    value = .round
                case "miter":
                    value = .miter
                default:
                    value = .miter // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnLineJoin: value))
        }
    }
    
    private func expressionForLineTranslateAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNLineTranslationAnchor
            
            switch anchor.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .map // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnLineTranslationAnchor: value))
        }
    }
    
    // MARK: Transition creation helper
    private func transitionFromDictionary(_ dict: [String: Any]) -> MLNTransition {
        let duration = dict["duration"] as? TimeInterval ?? 0
        let delay = dict["delay"] as? TimeInterval ?? 0
        
        return MLNTransition(duration: duration / 1000, delay: delay / 1000)
    }
}
