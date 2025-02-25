//
//  LayerArgsParser.swift
//  naxalibre
//
//  Created by Amit on 24/02/2025.
//

import Foundation
import MapLibre

class LayerArgsParser {
    /// Parses a dictionary of arguments to create a MapLibre layer.
    /// - Parameters:
    ///   - args: A dictionary containing layer details.
    ///   - source: The `MLNSource` object to which the layer will be attached. Can be `nil` for background layers.
    /// - Returns: A configured `MLNStyleLayer` object or `nil` if parsing fails.
    ///
    static func parseArgs(_ args: [String: Any?], source: MLNSource?) -> MLNStyleLayer? {
        // Ensure the 'type' key is present and valid
        guard let typeString = args["type"] as? String,
              let type = NaxaLibreLayerType(rawValue: typeString) else {
            return nil
        }
        
        // Ensure 'source' is provided for layers that require it
        if type != .background && source == nil {
            return nil
        }
        
        // Define a dictionary mapping layer types to their respective parser functions
        let parsers: [NaxaLibreLayerType: ([String: Any?], MLNSource) -> MLNStyleLayer?] = [
            .symbol: SymbolLayerArgsParser.parseArgs,
            .fill: FillLayerArgsParser.parseArgs,
            .line: LineLayerArgsParser.parseArgs,
            .circle: CircleLayerArgsParser.parseArgs,
            .raster: RasterLayerArgsParser.parseArgs,
            .fillExtrusion: FillExtrusionLayerArgsParser.parseArgs,
            .heatmap: HeatmapLayerArgsParser.parseArgs,
            .hillshade: HillShadeLayerArgsParser.parseArgs,
            .background: { args, _ in BackgroundLayerArgsParser.parseArgs(args) }
        ]
        
        // Call the appropriate parser function
        if let parser = parsers[type] {
            return parser(args, source!)
        }
        
        return nil
    }
}


/// Enum for layer types supported in NaxaLibre
fileprivate enum NaxaLibreLayerType: String {
    case symbol = "symbol-layer"
    case fill = "fill-layer"
    case line = "line-layer"
    case circle = "circle-layer"
    case raster = "raster-layer"
    case fillExtrusion = "fill-extrusion-layer"
    case heatmap = "heatmap-layer"
    case hillshade = "hillshade-layer"
    case background = "background-layer"
}
