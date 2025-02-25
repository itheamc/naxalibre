//
//  RasterLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre

struct RasterLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre raster layer.
    /// - Parameter args: A dictionary containing raster layer details.
    /// - Returns: A configured `MLNRasterStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource) -> MLNRasterStyleLayer? {
        guard let layerId = args["layerId"] as? String else {
            return nil
        }
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNRasterStyleLayer(identifier: layerId, source: source)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
        
        return layer
    }
}

/// Extension helper for the `MLNRasterStyleLayer`
///
fileprivate extension MLNRasterStyleLayer {
    
    // MARK: Configure Raster Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNRasterStyleLayer {
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
    
    // MARK: Method to configure raster layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNRasterStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let visibility = layoutProperties["visibility"] as? Bool {
                self.isVisible = visibility
            }
        }
        
        return self
    }
    
    // MARK: Method to configure raster layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNRasterStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let rasterBrightnessMax = paintProperties["raster-brightness-max"] {
                if let rasterBrightnessMaxExpression = NaxaLibreExpressionsUtils.expressionFromValue(rasterBrightnessMax) as NSExpression? {
                    self.maximumRasterBrightness = rasterBrightnessMaxExpression
                }
            }
            
            if let rasterBrightnessMin = paintProperties["raster-brightness-min"] {
                if let rasterBrightnessMinExpression = NaxaLibreExpressionsUtils.expressionFromValue(rasterBrightnessMin) as NSExpression? {
                    self.minimumRasterBrightness = rasterBrightnessMinExpression
                }
            }
            
            if let rasterContrast = paintProperties["raster-contrast"] {
                if let rasterContrastExpression = NaxaLibreExpressionsUtils.expressionFromValue(rasterContrast) as NSExpression? {
                    self.rasterContrast = rasterContrastExpression
                }
            }
            
            if let rasterFadeDuration = paintProperties["raster-fade-duration"] {
                if let rasterFadeDurationExpression = NaxaLibreExpressionsUtils.expressionFromValue(rasterFadeDuration) as NSExpression? {
                    self.rasterFadeDuration = rasterFadeDurationExpression
                }
            }
            
            if let rasterHueRotate = paintProperties["raster-hue-rotate"] {
                if let rasterHueRotateExpression = NaxaLibreExpressionsUtils.expressionFromValue(rasterHueRotate) as NSExpression? {
                    self.rasterHueRotation = rasterHueRotateExpression
                }
            }
            
            if let rasterOpacity = paintProperties["raster-opacity"] {
                if let rasterOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(rasterOpacity) as NSExpression? {
                    self.rasterOpacity = rasterOpacityExpression
                }
            }
            
            if let rasterSaturation = paintProperties["raster-saturation"] {
                if let rasterSaturationExpression = NaxaLibreExpressionsUtils.expressionFromValue(rasterSaturation) as NSExpression? {
                    self.rasterSaturation = rasterSaturationExpression
                }
            }
            
            if let rasterResampling = paintProperties["raster-resampling"] as? String {
                self.rasterResamplingMode = expressionForRasterResampling(rasterResampling)
            }
        }
        
        return self
    }
    
    // MARK: Method to configure raster layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNRasterStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let rasterBrightnessMaxTransition = transitionProperties["raster-brightness-max-transition"] as? [String: Any] {
                self.maximumRasterBrightnessTransition = transitionFromDictionary(rasterBrightnessMaxTransition)
            }
            
            if let rasterBrightnessMinTransition = transitionProperties["raster-brightness-min-transition"] as? [String: Any] {
                self.minimumRasterBrightnessTransition = transitionFromDictionary(rasterBrightnessMinTransition)
            }
            
            if let rasterContrastTransition = transitionProperties["raster-contrast-transition"] as? [String: Any] {
                self.rasterContrastTransition = transitionFromDictionary(rasterContrastTransition)
            }
            
            if let rasterHueRotateTransition = transitionProperties["raster-hue-rotate-transition"] as? [String: Any] {
                self.rasterHueRotationTransition = transitionFromDictionary(rasterHueRotateTransition)
            }
            
            if let rasterOpacityTransition = transitionProperties["raster-opacity-transition"] as? [String: Any] {
                self.rasterOpacityTransition = transitionFromDictionary(rasterOpacityTransition)
            }
            
            if let rasterSaturationTransition = transitionProperties["raster-saturation-transition"] as? [String: Any] {
                self.rasterSaturationTransition = transitionFromDictionary(rasterSaturationTransition)
            }
        }
        
        return self
    }
    
    // MARK: Helper Methods for Enum-Based Properties
    private func expressionForRasterResampling(_ resampling: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(resampling) {
            return expression
        } else {
            let value: MLNRasterResamplingMode
            
            switch resampling.lowercased() {
                case "linear":
                    value = .linear
                case "nearest":
                    value = .nearest
                default:
                    value = .linear // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnRasterResamplingMode: value))
        }
    }
    
    // MARK: Transition creation helper
    private func transitionFromDictionary(_ dict: [String: Any]) -> MLNTransition {
        let duration = dict["duration"] as? TimeInterval ?? 0
        let delay = dict["delay"] as? TimeInterval ?? 0
        
        return MLNTransition(duration: duration, delay: delay)
    }
}
