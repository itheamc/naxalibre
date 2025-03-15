//
//  OfflineRegionDefinitionArgsParser.swift
//  naxalibre
//
//  Created by Amit on 14/03/2025.
//

import Foundation
import MapLibre

/**
 * Utility class responsible for parsing arguments and constructing OfflineRegionDefinition instances.
 *
 * This class provides a single method, `parseArgs`, to create either an OfflineTilePyramidRegionDefinition
 * or an OfflineGeometryRegionDefinition based on the provided arguments. It handles various inputs
 * such as bounds, geometry, style URL, zoom levels, and pixel ratio, ensuring proper validation and default values.
 */
class OfflineRegionDefinitionArgsParser {
    
    /**
     * Parses the given arguments to construct an OfflineRegionDefinition.
     *
     * - Parameters:
     *   - args: A dictionary containing the arguments required for creating an offline region definition.
     *   - libreMap: The MLNMapView instance to fetch the style URL.
     * - Returns: A constructed OfflineRegionDefinition instance.
     */
    static func parseArgs(
        args: [AnyHashable: Any?],
        libreView: MLNMapView
    ) -> MLNOfflineRegion {
        
        // LatLng Bounds
        let boundsArgs = args["bounds"] as? [String: Any]
        
        // Geometry
        let geometryArgs = args["geometry"] as? [String: Any]
        
        // Style URL
        let styleURL = (args["styleUrl"] as? String) ?? libreView.styleURL?.absoluteString
        
        // Min Zoom
        let minZoom = (args["minZoom"] as? Double) ?? libreView.minimumZoomLevel
        
        // Max Zoom
        let maxZoom = (args["maxZoom"] as? Double) ?? libreView.maximumZoomLevel
        
        // Include Ideographs
        let includeIdeographs = (args["includeIdeographs"] as? Bool) ?? true
        
        // If bounds args and geometry args both are null, throw an exception
        if boundsArgs == nil && geometryArgs == nil {
            fatalError("Either 'bounds' or 'geometry' must be provided")
        }
        
        // If bounds args is not null, parse it
        // and return an MLNTilePyramidOfflineRegion
        if let boundsArgs = boundsArgs {
            let northEast = boundsArgs["northeast"] as? [Double]
            let southWest = boundsArgs["southwest"] as? [Double]
            
            if northEast == nil || southWest == nil {
                fatalError("Invalid bounds format")
            }
            
            let southwest = CLLocationCoordinate2D(latitude: southWest![0], longitude: southWest![1])
            let northeast = CLLocationCoordinate2D(latitude: northEast![0], longitude: northEast![1])
            let coordinateBounds = MLNCoordinateBounds(sw: southwest, ne: northeast)
            
            let pyramidOfflineRegion  = MLNTilePyramidOfflineRegion(
                styleURL: URL(string: styleURL!)!,
                bounds: coordinateBounds,
                fromZoomLevel: minZoom,
                toZoomLevel: maxZoom
            )
            
            pyramidOfflineRegion.includesIdeographicGlyphs = includeIdeographs
            
            return pyramidOfflineRegion
        }
        
        // Else parse geometry args
        // and return an MLNGeometryOfflineRegion
        let geometry = GeometryArgsParser.parseArgs(args: geometryArgs!)
        
        return MLNShapeOfflineRegion(
            styleURL: URL(string: styleURL!)!,
            shape: geometry!,
            fromZoomLevel: minZoom,
            toZoomLevel: maxZoom
        )
    }
}
