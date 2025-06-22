//
//  UpdateLayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 22/06/2025.
//

import Foundation
import MapLibre

class UpdateLayerArgsParser {
    /// Parses a dictionary of arguments to updatre a MapLibre layer.
    /// - Parameters:
    ///   - args: A dictionary containing layer details.
    ///   - layer: The `MLNStyleLayer` object to which will be updated.
    ///
    static func parseArgs(_ layer: MLNStyleLayer?, _ args: [String: Any?]) throws {
        
        if let layer = layer as? MLNCircleStyleLayer {
            CircleLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else if let layer = layer as? MLNLineStyleLayer {
            LineLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else if let layer = layer as? MLNFillStyleLayer {
            FillLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else if let layer = layer as? MLNSymbolStyleLayer {
            SymbolLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else if let layer = layer as? MLNFillExtrusionStyleLayer {
            FillExtrusionLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else if let layer = layer as? MLNHeatmapStyleLayer {
            HeatmapLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else if let layer = layer as? MLNRasterStyleLayer {
            RasterLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else if let layer = layer as? MLNHillshadeStyleLayer {
            HillShadeLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else if let layer = layer as? MLNBackgroundStyleLayer {
            BackgroundLayerArgsParser.parseArgsAndUpdate(layer, args)
        } else {
            throw NSError(
                domain: "NaxaLibreController",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Unable to update layer as layer with provided id is not found"]
            )
        }
        
    }
}
