//
//  SourceArgsParser.swift
//  naxalibre
//
//  Created by Amit on 24/02/2025.
//

import Foundation
import MapLibre

/// Utility class for creating map sources from a dictionary of arguments.
///
/// This class provides a factory method, `parseArgs`, to dynamically construct various types of map sources
/// (GeoJSON, Vector, Raster, Raster-DEM, Image) based on the provided configuration.
class SourceArgsParser {
    
    /// Creates a `Source` object from a dictionary of arguments.
    ///
    /// - Parameter args: Dictionary containing source configuration
    /// - Returns: Configured map source
    /// - Throws: SourceError if the configuration is invalid
    static func parseArgs(_ args: [String: Any?]) throws -> MLNSource {
        guard let type = args["type"] as? String,
              let details = args["details"] as? [String: Any],
              !details.isEmpty,
              let sourceId = details["id"] as? String else {
            throw NSError(domain: "Invalid source configuration", code: 0, userInfo: nil)
        }
        
        let properties = details["properties"] as? [String: Any]
        
        switch type {
            case "geojson":
                return try createGeoJSONSource(sourceId: sourceId, details: details, properties: properties)
                
            case "vector":
                return try createVectorSource(sourceId: sourceId, details: details, properties: properties)
                
            case "raster":
                return try createRasterSource(sourceId: sourceId, details: details, properties: properties)
                
            case "raster-dem":
                return try createRasterDemSource(sourceId: sourceId, details: details, properties: properties)
                
            case "image":
                return try createImageSource(sourceId: sourceId, details: details, properties: properties)
                
            default:
                throw NSError(domain: "Unsupported source type: \(type)", code: 0, userInfo:nil)
        }
    }
    
    // MARK: - Private Helper Methods
    
    private static func createGeoJSONSource(sourceId: String, details: [String: Any], properties: [String: Any]?) throws -> MLNShapeSource {
        let url = details["url"] as? String
        let data = details["data"] as? String
        
        guard url != nil || data != nil else {
            throw NSError(domain: "GeoJSON source must specify either a 'url' or 'data' property", code: 0, userInfo:nil)
        }
        
        let options = shapeSourceOptions(with: properties)
        
        if let url = url {
            let geoJSONURL = URL(string: url)!
            return MLNShapeSource(identifier: sourceId, url: geoJSONURL, options: options)
        } else {
            if let geoJSONData = data!.data(using: .utf8) {
                do {
                    // Parse the GeoJSON data into a shape
                    let shape = try MLNShape(data: geoJSONData, encoding: String.Encoding.utf8.rawValue)
                    
                    // Create a source with the GeoJSON shape
                    let source = MLNShapeSource(identifier: sourceId, shape: shape, options: options)
                    
                    // return source
                    return source
                    
                } catch {
                    throw NSError(domain: "Invalid GeoJSON", code: 0, userInfo: nil)
                }
            } else {
                throw NSError(domain: "Invalid GeoJSON", code: 0, userInfo: nil)
            }

        }
    }
    
    private static func createVectorSource(sourceId: String, details: [String: Any], properties: [String: Any]?) throws -> MLNVectorTileSource {
        let url = details["url"] as? String
        let tileSetArgs = details["tileSet"] as? [String: Any]
        
        guard url != nil || (!tileSetArgs.isNil && (tileSetArgs?["tiles"] as? [String]) != nil) else {
            throw NSError(domain: "Invalid raster tile source", code: 1001, userInfo: nil)
        }
        
        var tiles: [URL] = []
        if let tileSetTiles = tileSetArgs?["tiles"] as? [String] {
            tiles = tileSetTiles.compactMap { URL(string: $0) }
        }
        
        let options = tileSourceOptions(with: properties)
        
        if let url = url, let tileURL = URL(string: url) {
            return MLNVectorTileSource(
                identifier: sourceId,
                configurationURL: tileURL,
            )
        }
        
        return MLNVectorTileSource(
            identifier: sourceId,
            tileURLTemplates: tiles.map(\.absoluteString),
            options: options
        )
    }
    
    private static func createRasterSource(sourceId: String, details: [String: Any], properties: [String: Any]?) throws -> MLNRasterTileSource {
        let url = details["url"] as? String
        let tileSetArgs = details["tileSet"] as? [String: Any]
        
        guard url != nil || (!tileSetArgs.isNil && (tileSetArgs?["tiles"] as? [String]) != nil) else {
            throw NSError(domain: "Invalid raster tile source", code: 1001, userInfo: nil)
        }
        
        var tiles: [URL] = []
        if let tileSetTiles = tileSetArgs?["tiles"] as? [String] {
            tiles = tileSetTiles.compactMap { URL(string: $0) }
        }
        
        let options = tileSourceOptions(with: properties)
        
        if let url = url, let tileURL = URL(string: url) {
            return MLNRasterTileSource(
                identifier: sourceId,
                configurationURL: tileURL,
                tileSize: options[.tileSize] as! CGFloat
            )
        }
        
        return MLNRasterTileSource(
            identifier: sourceId,
            tileURLTemplates: tiles.map(\.absoluteString),
            options: options
        )
    }
    
    private static func createRasterDemSource(sourceId: String, details: [String: Any], properties: [String: Any]?) throws -> MLNRasterDEMSource {
        let url = details["url"] as? String
        let tileSetArgs = details["tileSet"] as? [String: Any]
        
        guard url != nil || (!tileSetArgs.isNil && (tileSetArgs?["tiles"] as? [String]) != nil) else {
            throw NSError(domain: "Invalid RasterDEMSource source", code: 1001, userInfo: nil)
        }
        
        var tiles: [URL] = []
        if let tileSetTiles = tileSetArgs?["tiles"] as? [String] {
            tiles = tileSetTiles.compactMap { URL(string: $0) }
        }
        
        let options = tileSourceOptions(with: properties)
        
        if let url = url, let tileURL = URL(string: url) {
            return MLNRasterDEMSource(
                identifier: sourceId,
                configurationURL: tileURL,
                tileSize: options[.tileSize] as! CGFloat
            )
        }
        
        return MLNRasterDEMSource(
            identifier: sourceId,
            tileURLTemplates: tiles.map(\.absoluteString),
            options: options
        )
    }
    
    private static func createImageSource(sourceId: String, details: [String: Any], properties: [String: Any]?) throws -> MLNImageSource {
        guard let urlStr = details["url"] as? String,
              let coordinates = details["coordinates"] as? [String: Any],
              let topLeft = coordinates["top_left"] as? [Double],
              let topRight = coordinates["top_right"] as? [Double],
              let bottomRight = coordinates["bottom_right"] as? [Double],
              let bottomLeft = coordinates["bottom_left"] as? [Double],
              let url = URL(string: urlStr),
              topLeft.count == 2,
              topRight.count == 2,
              bottomRight.count == 2,
              bottomLeft.count == 2 else {
            throw NSError(domain: "Invalid Image Source", code: 0, userInfo: nil)
        }
        
        let quad = MLNCoordinateQuad(
            topLeft: CLLocationCoordinate2D(latitude: topLeft[0], longitude: topLeft[1]),
            bottomLeft: CLLocationCoordinate2D(latitude: bottomLeft[0], longitude: bottomLeft[1]),
            bottomRight: CLLocationCoordinate2D(latitude: bottomRight[0], longitude: bottomRight[1]),
            topRight: CLLocationCoordinate2D(latitude: topRight[0], longitude: topRight[1])
        )

        let source = MLNImageSource(identifier: sourceId, coordinateQuad: quad, url: url)
        return source
    }
    
    // MARK: - Source Options Builder Methods
    
    private static func shapeSourceOptions(with properties: [String: Any]?) -> [MLNShapeSourceOption: Any] {
        var options: [MLNShapeSourceOption: Any] = [:]
        
        if let properties = properties {
            if let minZoom = properties["minzoom"] as? Int {
                options[.minimumZoomLevel] = minZoom
            }
            if let maxZoom = properties["maxzoom"] as? Int {
                options[.maximumZoomLevel] = maxZoom
            }
            if let buffer = properties["buffer"] as? Int {
                options[.buffer] = buffer
            }
            if let lineMetrics = properties["lineMetrics"] as? Bool {
                options[.lineDistanceMetrics] = lineMetrics
            }
            if let tolerance = properties["tolerance"] as? Double {
                options[.simplificationTolerance] = tolerance
            }
            if let cluster = properties["cluster"] as? Bool {
                options[.clustered] = cluster
            }
            if let clusterRadius = properties["clusterRadius"] as? Int {
                options[.clusterRadius] = clusterRadius
            }
            if let clusterMaxZoom = properties["clusterMaxZoom"] as? Int {
                options[.maximumZoomLevelForClustering] = clusterMaxZoom
            }
        }
        
        return options
    }
    
    private static func tileSourceOptions(with properties: [String: Any]?) -> [MLNTileSourceOption: Any] {
        var options: [MLNTileSourceOption: Any] = [:]
        
        if let properties = properties {
            
            if let minZoom = properties["minzoom"] as? Int {
                options[.minimumZoomLevel] = minZoom
            }
            
            if let maxZoom = properties["maxzoom"] as? Int {
                options[.maximumZoomLevel] = maxZoom
            }
            
            if let attribution = properties["attribution"] as? String {
                options[.attributionHTMLString] = attribution
            }
            
            if let encoding = properties["encoding"] as? String {
                options[.demEncoding] = encoding
            }
            
            if let tileSize = properties["tileSize"] as? Int {
                options[.tileSize] = CGFloat(tileSize)
            } else {
                options[.tileSize] = CGFloat(256)
            }
            
            if let scheme = properties["scheme"] as? String {
                options[.tileCoordinateSystem] = scheme == "tms" ? MLNTileCoordinateSystem.TMS : MLNTileCoordinateSystem.XYZ
            }
            
            if let bounds = properties["bounds"] as? [String: Any],
               let southwest = bounds["southwest"] as? [Double],
               let northeast = bounds["northeast"] as? [Double] {
                let boundingBox = MLNCoordinateBounds(
                    sw: CLLocationCoordinate2D(latitude: southwest[0], longitude: southwest[1]),
                    ne: CLLocationCoordinate2D(latitude: northeast[0], longitude: northeast[1])
                )
                
                options[.coordinateBounds] = boundingBox
            }
            
            if properties["volatile"] is Bool {
                // Not supported in Ios
            }
            if properties["prefetchZoomDelta"] is Int {
                // Not supported in Ios
            }
            if properties["minimumTileUpdateInterval"] is Double {
                // Not supported in Ios
            }
            if properties["maxOverScaleFactorForParentTiles"] is Int {
                // Not supported in Ios
            }
        }
        
        return options
    }
}

// MARK: - Optional Extensions
fileprivate extension Optional {
    var isNil: Bool {
        self == nil
    }
}
