//
//  SymbolLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre


struct SymbolLayerArgsParser {
    
    /// Parses a dictionary of arguments to create a MapLibre symbol layer.
    /// - Parameter args: A dictionary containing symbol layer details.
    /// - Returns: A configured `MLNSymbolStyleLayer` object or `nil`.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource) -> MLNSymbolStyleLayer? {
        guard let layerId = args["layerId"] as? String else {
            return nil
        }
        
        let properties = args["properties"] as? [String: Any?]
        
        let layer = MLNSymbolStyleLayer(identifier: layerId, source: source)
            .configureLayerArgs(properties)
            .configureLayoutArgs(properties)
            .configurePaintArgs(properties)
            .configureTransitionArgs(properties)
        
        return layer
    }
}

/// Extension helper for the `MLNSymbolStyleLayer`
///
fileprivate extension MLNSymbolStyleLayer {
    
    // MARK: Configure Layer Args
    func configureLayerArgs(_ properties: [String: Any?]?) -> MLNSymbolStyleLayer {
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
    
    // MARK: Method to configure symbol layer layout properties
    func configureLayoutArgs(_ properties: [String: Any?]?) -> MLNSymbolStyleLayer {
        
        if let properties = properties {
            let layoutProperties: [String: Any?] = properties["layout"] as? [String: Any?] ?? [:]
            
            if let iconAllowOverlap = layoutProperties["icon-allow-overlap"] {
                if let iconAllowOverlapExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconAllowOverlap) as NSExpression? {
                    self.iconAllowsOverlap = iconAllowOverlapExpression
                }
            }
            
            if let iconAnchor = layoutProperties["icon-anchor"] as? String {
                self.iconAnchor = expressionForIconAnchor(iconAnchor)
            }
            
            if let iconIgnorePlacement = layoutProperties["icon-ignore-placement"] {
                if let iconIgnorePlacementExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconIgnorePlacement) as NSExpression? {
                    self.iconIgnoresPlacement = iconIgnorePlacementExpression
                }
            }
            
            if let iconImage = layoutProperties["icon-image"] {
                if let iconImageExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconImage) as NSExpression? {
                    self.iconImageName = iconImageExpression
                }
            }
            
            if let iconKeepUpright = layoutProperties["icon-keep-upright"] {
                if let iconKeepUprightExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconKeepUpright) as NSExpression? {
                    self.keepsIconUpright = iconKeepUprightExpression
                }
            }
            
            if let iconOffset = layoutProperties["icon-offset"] as? [CGFloat], iconOffset.count == 2 {
                if let iconOffsetExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconOffset) as NSExpression? {
                    self.iconOffset = iconOffsetExpression
                }
            }
            
            if let iconOptional = layoutProperties["icon-optional"] {
                if let iconOptionalExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconOptional) as NSExpression? {
                    self.iconOptional = iconOptionalExpression
                }
            }
            
            if let iconPadding = layoutProperties["icon-padding"] {
                if let iconPaddingExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconPadding) as NSExpression? {
                    self.iconPadding = iconPaddingExpression
                }
            }
            
            if let iconPitchAlignment = layoutProperties["icon-pitch-alignment"] as? String {
                self.iconPitchAlignment = expressionForIconPitchAlignment(iconPitchAlignment)
            }
            
            if let iconRotate = layoutProperties["icon-rotate"] {
                if let iconRotateExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconRotate) as NSExpression? {
                    self.iconRotation = iconRotateExpression
                }
            }
            
            if let iconRotationAlignment = layoutProperties["icon-rotation-alignment"] as? String {
                self.iconRotationAlignment = expressionForIconRotationAlignment(iconRotationAlignment)
            }
            
            if let iconSize = layoutProperties["icon-size"] {
                if let iconSizeExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconSize) as NSExpression? {
                    self.iconScale = iconSizeExpression
                }
            }
            
            if let iconTextFit = layoutProperties["icon-text-fit"] as? String {
                self.iconTextFit = expressionForIconTextFit(iconTextFit)
            }
            
            if let iconTextFitPadding = layoutProperties["icon-text-fit-padding"] as? [CGFloat], iconTextFitPadding.count == 4 {
                if let iconTextFitPaddingExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconTextFitPadding) as NSExpression? {
                    self.iconTextFitPadding = iconTextFitPaddingExpression
                }
            }
            
            if let symbolAvoidEdges = layoutProperties["symbol-avoid-edges"] {
                if let symbolAvoidEdgesExpression = NaxaLibreExpressionsUtils.expressionFromValue(symbolAvoidEdges) as NSExpression? {
                    self.symbolAvoidsEdges = symbolAvoidEdgesExpression
                }
            }
            
            if let symbolPlacement = layoutProperties["symbol-placement"] as? String {
                self.symbolPlacement = expressionForSymbolPlacement(symbolPlacement)
            }
            
            if let symbolSortKey = layoutProperties["symbol-sort-key"] {
                if let symbolSortKeyExpression = NaxaLibreExpressionsUtils.expressionFromValue(symbolSortKey) as NSExpression? {
                    self.symbolSortKey = symbolSortKeyExpression
                }
            }
            
            if let symbolSpacing = layoutProperties["symbol-spacing"] {
                if let symbolSpacingExpression = NaxaLibreExpressionsUtils.expressionFromValue(symbolSpacing) as NSExpression? {
                    self.symbolSpacing = symbolSpacingExpression
                }
            }
            
            if let symbolZOrder = layoutProperties["symbol-z-order"] as? String {
                self.symbolZOrder = expressionForSymbolZOrder(symbolZOrder)
            }
            
            if let textAllowOverlap = layoutProperties["text-allow-overlap"] {
                if let textAllowOverlapExpression = NaxaLibreExpressionsUtils.expressionFromValue(textAllowOverlap) as NSExpression? {
                    self.textAllowsOverlap = textAllowOverlapExpression
                }
            }
            
            if let textAnchor = layoutProperties["text-anchor"] as? String {
                self.textAnchor = expressionForTextAnchor(textAnchor)
            }
            
            if let textField = layoutProperties["text-field"] {
                if let textFieldExpression = NaxaLibreExpressionsUtils.expressionFromValue(textField) as NSExpression? {
                    self.text = textFieldExpression
                }
            }
            
            if let textFont = layoutProperties["text-font"] as? [String] {
                if let textFontExpression = NaxaLibreExpressionsUtils.expressionFromValue(textFont) as NSExpression? {
                    self.textFontNames = textFontExpression
                }
            }
            
            if let textIgnorePlacement = layoutProperties["text-ignore-placement"] {
                if let textIgnorePlacementExpression = NaxaLibreExpressionsUtils.expressionFromValue(textIgnorePlacement) as NSExpression? {
                    self.textIgnoresPlacement = textIgnorePlacementExpression
                }
            }
            
            if let textJustify = layoutProperties["text-justify"] as? String {
                self.textJustification = expressionForTextJustify(textJustify)
            }
            
            if let textKeepUpright = layoutProperties["text-keep-upright"] {
                if let textKeepUprightExpression = NaxaLibreExpressionsUtils.expressionFromValue(textKeepUpright) as NSExpression? {
                    self.keepsTextUpright = textKeepUprightExpression
                }
            }
            
            if let textLetterSpacing = layoutProperties["text-letter-spacing"] {
                if let textLetterSpacingExpression = NaxaLibreExpressionsUtils.expressionFromValue(textLetterSpacing) as NSExpression? {
                    self.textLetterSpacing = textLetterSpacingExpression
                }
            }
            
            if let textLineHeight = layoutProperties["text-line-height"] {
                if let textLineHeightExpression = NaxaLibreExpressionsUtils.expressionFromValue(textLineHeight) as NSExpression? {
                    self.textLineHeight = textLineHeightExpression
                }
            }
            
            if let textMaxAngle = layoutProperties["text-max-angle"] {
                if let textMaxAngleExpression = NaxaLibreExpressionsUtils.expressionFromValue(textMaxAngle) as NSExpression? {
                    self.maximumTextAngle = textMaxAngleExpression
                }
            }
            
            if let textMaxWidth = layoutProperties["text-max-width"] {
                if let textMaxWidthExpression = NaxaLibreExpressionsUtils.expressionFromValue(textMaxWidth) as NSExpression? {
                    self.maximumTextWidth = textMaxWidthExpression
                }
            }
            
            if let textOffset = layoutProperties["text-offset"] as? [CGFloat], textOffset.count == 2 {
                if let textOffsetExpression = NaxaLibreExpressionsUtils.expressionFromValue(textOffset) as NSExpression? {
                    self.textOffset = textOffsetExpression
                }
            }
            
            if let textOptional = layoutProperties["text-optional"] {
                if let textOptionalExpression = NaxaLibreExpressionsUtils.expressionFromValue(textOptional) as NSExpression? {
                    self.textOptional = textOptionalExpression
                }
            }
            
            if let textPadding = layoutProperties["text-padding"] {
                if let textPaddingExpression = NaxaLibreExpressionsUtils.expressionFromValue(textPadding) as NSExpression? {
                    self.textPadding = textPaddingExpression
                }
            }
            
            if let textPitchAlignment = layoutProperties["text-pitch-alignment"] as? String {
                self.textPitchAlignment = expressionForTextPitchAlignment(textPitchAlignment)
            }
            
            if let textRadialOffset = layoutProperties["text-radial-offset"] {
                if let textRadialOffsetExpression = NaxaLibreExpressionsUtils.expressionFromValue(textRadialOffset) as NSExpression? {
                    self.textRadialOffset = textRadialOffsetExpression
                }
            }
            
            if let textRotate = layoutProperties["text-rotate"] {
                if let textRotateExpression = NaxaLibreExpressionsUtils.expressionFromValue(textRotate) as NSExpression? {
                    self.textRotation = textRotateExpression
                }
            }
            
            if let textRotationAlignment = layoutProperties["text-rotation-alignment"] as? String {
                self.textRotationAlignment = expressionForTextRotationAlignment(textRotationAlignment)
            }
            
            if let textSize = layoutProperties["text-size"] {
                if let textSizeExpression = NaxaLibreExpressionsUtils.expressionFromValue(textSize) as NSExpression? {
                    self.textFontSize = textSizeExpression
                }
            }
            
            if let textTransform = layoutProperties["text-transform"] as? String {
                self.textTransform = expressionForTextTransform(textTransform)
            }
            
            if let textVariableAnchor = layoutProperties["text-variable-anchor"] as? [String] {
                if let textVariableAnchorExpression = NaxaLibreExpressionsUtils.expressionFromValue(textVariableAnchor) as NSExpression? {
                    self.textVariableAnchor = textVariableAnchorExpression
                }
            }
            
            if let textWritingMode = layoutProperties["text-writing-mode"] as? [String] {
                if let textWritingModeExpression = NaxaLibreExpressionsUtils.expressionFromValue(textWritingMode) as NSExpression? {
                    self.textWritingModes = textWritingModeExpression
                }
            }
            
            if let visibility = layoutProperties["visibility"] as? Bool {
                self.isVisible = visibility
            }
        }
        
        return self
    }
    
    // MARK: Method to configure symbol layer paint properties
    func configurePaintArgs(_ properties: [String: Any?]?) -> MLNSymbolStyleLayer {
        
        if let properties = properties {
            let paintProperties: [String: Any?] = properties["paint"] as? [String: Any?] ?? [:]
            
            if let iconColor = paintProperties["icon-color"] {
                if let iconColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconColor, isColor: true) as NSExpression? {
                    self.iconColor = iconColorExpression
                }
            }
            
            if let iconHaloBlur = paintProperties["icon-halo-blur"] {
                if let iconHaloBlurExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconHaloBlur) as NSExpression? {
                    self.iconHaloBlur = iconHaloBlurExpression
                }
            }
            
            if let iconHaloColor = paintProperties["icon-halo-color"] {
                if let iconHaloColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconHaloColor, isColor: true) as NSExpression? {
                    self.iconHaloColor = iconHaloColorExpression
                }
            }
            
            if let iconHaloWidth = paintProperties["icon-halo-width"] {
                if let iconHaloWidthExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconHaloWidth) as NSExpression? {
                    self.iconHaloWidth = iconHaloWidthExpression
                }
            }
            
            if let iconOpacity = paintProperties["icon-opacity"] {
                if let iconOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconOpacity) as NSExpression? {
                    self.iconOpacity = iconOpacityExpression
                }
            }
            
            if let iconTranslate = paintProperties["icon-translate"] as? [CGFloat], iconTranslate.count == 2 {
                if let iconTranslateExpression = NaxaLibreExpressionsUtils.expressionFromValue(iconTranslate) as NSExpression? {
                    self.iconTranslation = iconTranslateExpression
                }
            }
            
            if let iconTranslateAnchor = paintProperties["icon-translate-anchor"] as? String {
                self.iconTranslationAnchor = expressionForIconTranslationAnchor(iconTranslateAnchor)
            }
            
            if let textColor = paintProperties["text-color"] {
                if let textColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(textColor, isColor: true) as NSExpression? {
                    self.textColor = textColorExpression
                }
            }
            
            if let textHaloBlur = paintProperties["text-halo-blur"] {
                if let textHaloBlurExpression = NaxaLibreExpressionsUtils.expressionFromValue(textHaloBlur) as NSExpression? {
                    self.textHaloBlur = textHaloBlurExpression
                }
            }
            
            if let textHaloColor = paintProperties["text-halo-color"] {
                if let textHaloColorExpression = NaxaLibreExpressionsUtils.expressionFromValue(textHaloColor, isColor: true) as NSExpression? {
                    self.textHaloColor = textHaloColorExpression
                }
            }
            
            if let textHaloWidth = paintProperties["text-halo-width"] {
                if let textHaloWidthExpression = NaxaLibreExpressionsUtils.expressionFromValue(textHaloWidth) as NSExpression? {
                    self.textHaloWidth = textHaloWidthExpression
                }
            }
            
            if let textOpacity = paintProperties["text-opacity"] {
                if let textOpacityExpression = NaxaLibreExpressionsUtils.expressionFromValue(textOpacity) as NSExpression? {
                    self.textOpacity = textOpacityExpression
                }
            }
            
            if let textTranslate = paintProperties["text-translate"] as? [CGFloat], textTranslate.count == 2 {
                if let textTranslateExpression = NaxaLibreExpressionsUtils.expressionFromValue(textTranslate) as NSExpression? {
                    self.textTranslation = textTranslateExpression
                }
            }
            
            if let textTranslateAnchor = paintProperties["text-translate-anchor"] as? String {
                self.textTranslationAnchor = expressionForTextTranslationAnchor(textTranslateAnchor)
            }
        }
        
        return self
    }
    
    // MARK: Method to configure symbol layer transitions properties
    func configureTransitionArgs(_ properties: [String: Any?]?) -> MLNSymbolStyleLayer {
        
        if let properties = properties {
            let transitionProperties: [String: Any?] = properties["transition"] as? [String: Any?] ?? [:]
            
            if let iconColorTransition = transitionProperties["icon-color-transition"] as? [String: Any] {
                self.iconColorTransition = transitionFromDictionary(iconColorTransition)
            }
            
            if let iconHaloBlurTransition = transitionProperties["icon-halo-blur-transition"] as? [String: Any] {
                self.iconHaloBlurTransition = transitionFromDictionary(iconHaloBlurTransition)
            }
            
            if let iconHaloColorTransition = transitionProperties["icon-halo-color-transition"] as? [String: Any] {
                self.iconHaloColorTransition = transitionFromDictionary(iconHaloColorTransition)
            }
            
            if let iconHaloWidthTransition = transitionProperties["icon-halo-width-transition"] as? [String: Any] {
                self.iconHaloWidthTransition = transitionFromDictionary(iconHaloWidthTransition)
            }
            
            if let iconOpacityTransition = transitionProperties["icon-opacity-transition"] as? [String: Any] {
                self.iconOpacityTransition = transitionFromDictionary(iconOpacityTransition)
            }
            
            if let iconTranslateTransition = transitionProperties["icon-translate-transition"] as? [String: Any] {
                self.iconTranslationTransition = transitionFromDictionary(iconTranslateTransition)
            }
            
            if let textColorTransition = transitionProperties["text-color-transition"] as? [String: Any] {
                self.textColorTransition = transitionFromDictionary(textColorTransition)
            }
            
            if let textHaloBlurTransition = transitionProperties["text-halo-blur-transition"] as? [String: Any] {
                self.textHaloBlurTransition = transitionFromDictionary(textHaloBlurTransition)
            }
            
            if let textHaloColorTransition = transitionProperties["text-halo-color-transition"] as? [String: Any] {
                self.textHaloColorTransition = transitionFromDictionary(textHaloColorTransition)
            }
            
            if let textHaloWidthTransition = transitionProperties["text-halo-width-transition"] as? [String: Any] {
                self.textHaloWidthTransition = transitionFromDictionary(textHaloWidthTransition)
            }
            
            if let textOpacityTransition = transitionProperties["text-opacity-transition"] as? [String: Any] {
                self.textOpacityTransition = transitionFromDictionary(textOpacityTransition)
            }
            
            if let textTranslateTransition = transitionProperties["text-translate-transition"] as? [String: Any] {
                self.textTranslationTransition = transitionFromDictionary(textTranslateTransition)
            }
        }
        
        return self
    }
    
    // MARK: Helper Methods for Enum-Based Properties
    private func expressionForIconAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNIconAnchor
            
            switch anchor.lowercased() {
                case "center":
                    value = .center
                case "left":
                    value = .left
                case "right":
                    value = .right
                case "top":
                    value = .top
                case "bottom":
                    value = .bottom
                case "top-left":
                    value = .topLeft
                case "top-right":
                    value = .topRight
                case "bottom-left":
                    value = .bottomLeft
                case "bottom-right":
                    value = .bottomRight
                default:
                    value = .center // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnIconAnchor: value))
        }
    }
    
    private func expressionForIconPitchAlignment(_ alignment: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(alignment) {
            return expression
        } else {
            let value: MLNIconPitchAlignment
            
            switch alignment.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                case "auto":
                    value = .auto
                default:
                    value = .auto // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnIconPitchAlignment: value))
        }
    }
    
    private func expressionForIconRotationAlignment(_ alignment: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(alignment) {
            return expression
        } else {
            let value: MLNIconRotationAlignment
            
            switch alignment.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                case "auto":
                    value = .auto
                default:
                    value = .auto // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnIconRotationAlignment: value))
        }
    }
    
    private func expressionForIconTextFit(_ fit: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(fit) {
            return expression
        } else {
            let value: MLNIconTextFit
            
            switch fit.lowercased() {
                case "none":
                    value = .none
                case "width":
                    value = .width
                case "height":
                    value = .height
                case "both":
                    value = .both
                default:
                    value = .none // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnIconTextFit: value))
        }
    }
    
    private func expressionForSymbolPlacement(_ placement: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(placement) {
            return expression
        } else {
            let value: MLNSymbolPlacement
            
            switch placement.lowercased() {
                case "point":
                    value = .point
                case "line":
                    value = .line
                case "line-center":
                    value = .lineCenter
                default:
                    value = .point // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnSymbolPlacement: value))
        }
    }
    
    private func expressionForSymbolZOrder(_ zOrder: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(zOrder) {
            return expression
        } else {
            let value: MLNSymbolZOrder
            
            switch zOrder.lowercased() {
                case "auto":
                    value = .auto
                case "viewport-y":
                    value = .viewportY
                case "source":
                    value = .source
                default:
                    value = .auto // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnSymbolZOrder: value))
        }
    }
    
    private func expressionForTextAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNTextAnchor
            
            switch anchor.lowercased() {
                case "center":
                    value = .center
                case "left":
                    value = .left
                case "right":
                    value = .right
                case "top":
                    value = .top
                case "bottom":
                    value = .bottom
                case "top-left":
                    value = .topLeft
                case "top-right":
                    value = .topRight
                case "bottom-left":
                    value = .bottomLeft
                case "bottom-right":
                    value = .bottomRight
                default:
                    value = .center // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnTextAnchor: value))
        }
    }
    
    private func expressionForTextJustify(_ justify: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(justify) {
            return expression
        } else {
            let value: MLNTextJustification
            
            switch justify.lowercased() {
                case "auto":
                    value = .auto
                case "left":
                    value = .left
                case "center":
                    value = .center
                case "right":
                    value = .right
                default:
                    value = .auto // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnTextJustification: value))
        }
    }
    
    private func expressionForTextPitchAlignment(_ alignment: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(alignment) {
            return expression
        } else {
            let value: MLNTextPitchAlignment
            
            switch alignment.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                case "auto":
                    value = .auto
                default:
                    value = .auto // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnTextPitchAlignment: value))
        }
    }
    
    private func expressionForTextRotationAlignment(_ alignment: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(alignment) {
            return expression
        } else {
            let value: MLNTextRotationAlignment
            
            switch alignment.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                case "auto":
                    value = .auto
                default:
                    value = .auto // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnTextRotationAlignment: value))
        }
    }
    
    private func expressionForTextTransform(_ transform: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(transform) {
            return expression
        } else {
            let value: MLNTextTransform
            
            switch transform.lowercased() {
                case "none":
                    value = .none
                case "uppercase":
                    value = .uppercase
                case "lowercase":
                    value = .lowercase
                default:
                    value = .none // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnTextTransform: value))
        }
    }
    
    private func expressionForIconTranslationAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNIconTranslationAnchor
            
            switch anchor.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .map // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnIconTranslationAnchor: value))
        }
    }
    
    private func expressionForTextTranslationAnchor(_ anchor: String) -> NSExpression {
        if let expression = NaxaLibreExpressionsUtils.parseExpression(anchor) {
            return expression
        } else {
            let value: MLNTextTranslationAnchor
            
            switch anchor.lowercased() {
                case "map":
                    value = .map
                case "viewport":
                    value = .viewport
                default:
                    value = .map // Default value
            }
            
            return NSExpression(forConstantValue: NSValue(mlnTextTranslationAnchor: value))
        }
    }
    
    // MARK: Transition creation helper
    private func transitionFromDictionary(_ dict: [String: Any]) -> MLNTransition {
        let duration = dict["duration"] as? TimeInterval ?? 0
        let delay = dict["delay"] as? TimeInterval ?? 0
        
        return MLNTransition(duration: duration, delay: delay)
    }
}
