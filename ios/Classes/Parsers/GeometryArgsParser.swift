//
//  GeometryArgsParser.swift
//  naxalibre
//
//  Created by Amit on 14/03/2025.
//

import Foundation
import MapLibre

/**
 * Utility class for parsing GeoJSON Geometry arguments.
 *
 * This class provides a function to parse a dictionary of arguments into a GeoJSON Geometry object.
 * It handles the conversion from a dictionary representation of a GeoJSON object to the corresponding
 * `MLNShape` subclass.
 */
class GeometryArgsParser {
    
    /**
     * Parses a dictionary of arguments into a GeoJSON Geometry object.
     *
     * This function takes a dictionary of arguments, typically representing a GeoJSON object, and attempts to
     * deserialize it into a specific GeoJSON Geometry type. It expects the dictionary to contain a "type"
     * key, which determines the specific GeoJSON geometry type. The rest of the dictionary is then converted to JSON format to be able to be parsed.
     *
     * - Parameter args: A dictionary containing the GeoJSON object's data. It must contain a "type" key whose value
     *                  is a string representing the GeoJSON type (e.g., "Point", "LineString", etc.).
     *                  Other keys and values in the dictionary represent the geometry's coordinates and
     *                  other properties.
     * - Returns: A MLNGeometry object corresponding to the specified type in the dictionary, or `nil` if:
     *          - The "type" key is missing or its value is not a string.
     *          - The "type" value is not one of the supported GeoJSON geometry types.
     *          - An error occurred during the deserialization of the JSON data.
     */
    static func parseArgs(args: [String: Any]) -> MLNShape? {
        // Extract the type from the args dictionary
        // If type is null, return null
        guard let type = args["type"] as? String else {
            return nil
        }
        
        // Extract the coordinateArgs from the args dictionary
        // If coordinates is null, return null
        guard let coordinateArgs = args["coordinates"] as? [Any] else {
            return nil
        }
        
        // Convert the JSON string to a Geometry object
        // as per type and return it
        switch type {
            case "Point":
                
                // Mapping list with double value
                let coordinates = coordinateArgs.compactMap { ($0 as? NSNumber)?.doubleValue }
                guard coordinates.count >= 2 else {
                    return nil
                }
                
                // Create a point geometry
                let point = MLNPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])

                // Return point shape / geometry
                return point
                
            case "LineString":
                // Creating coordinates
                var coordinates: [CLLocationCoordinate2D] = []
                for points in coordinateArgs as! [[Any]] {
                    guard points.count >= 2,
                          let lat = points[0] as? Double,
                          let lng = points[1] as? Double else {
                        continue
                    }
                    coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                }
                
                // If coordinates is empty return nil
                guard !coordinates.isEmpty else {
                    return nil
                }
                
                // Create a polyline geometry and return it
                return MLNPolyline(coordinates: coordinates, count: UInt(coordinates.count))
                
            case "Polygon":
                
                // Creating polygon coordinates
                var polygonCoordinates: [[CLLocationCoordinate2D]] = []
                
                for ring in coordinateArgs {
                    var ringCoordinates: [CLLocationCoordinate2D] = []
                    for point in ring as! [[Any]] {
                        guard point.count >= 2,
                              let lat = point[0] as? Double,
                              let lng = point[1] as? Double else {
                            continue
                        }
                        ringCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    }
                    
                    if !ringCoordinates.isEmpty {
                        polygonCoordinates.append(ringCoordinates)
                    }
                }
                
                // If polygon coordinates is empty return nil
                guard !polygonCoordinates.isEmpty else {
                    return nil
                }
                
                // Create polygon geometries
                // For simplicity, we'll assume there's only one ring of coordinates
                guard let coordinates = polygonCoordinates.first else {
                    return nil
                }
                
                // Create a polygon geometry and return it
                return MLNPolygon(coordinates: coordinates, count: UInt(coordinates.count))
                
            case "MultiPoint":
                
                // Creating coordinates
                var coordinates: [CLLocationCoordinate2D] = []
                for points in coordinateArgs as! [[Any]] {
                    guard points.count >= 2,
                          let lat = points[0] as? Double,
                          let lng = points[1] as? Double else {
                        continue
                    }
                    coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                }
                
                // If coordinates is empty return nil
                guard !coordinates.isEmpty else {
                    return nil
                }
                
                // Creating multipoint instance
                let multiPoint = MLNMultiPoint()
                
                // Adding coordinates to multipoint
                multiPoint.appendCoordinates(coordinates, count: UInt(coordinates.count))
                
                // Return multipoint
                return multiPoint
               
            case "MultiLineString":
                // Creating multi polylines list
                var multiPolylines: [MLNPolyline] = []
                
                // Iterate through the coordinateArgs and create polyline
                for group in coordinateArgs {
                    var groupCoordinates: [CLLocationCoordinate2D] = []
                    for point in group as! [[Any]] {
                        guard point.count >= 2,
                              let lat = point[0] as? Double,
                              let lng = point[1] as? Double else {
                            continue
                        }
                        groupCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                    }
                    
                    if !groupCoordinates.isEmpty {
                        multiPolylines.append(MLNPolyline(coordinates: groupCoordinates, count: UInt(groupCoordinates.count)))
                    }
                }
                
                // If multi polylines is empty return nil
                guard !multiPolylines.isEmpty else {
                    return nil
                }
                
                // Return multi polyline
                return MLNMultiPolyline(polylines: multiPolylines)
                
            case "MultiPolygon":
                // Creating multi polygons list
                var multiPolygons: [MLNPolygon] = []
                
                // Iterate through the coordinateArgs and create polygons
                for group in coordinateArgs {
                    var polygons: [MLNPolygon] = []
                    
                    for polygon in group as! [[[Any]]] {
                        var polygonCoordinates: [CLLocationCoordinate2D] = []
                        
                        for point in polygon {
                            guard point.count >= 2,
                                  let lat = point[0] as? Double,
                                  let lng = point[1] as? Double else {
                                continue
                            }
                            polygonCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
                        }
                        
                        if !polygonCoordinates.isEmpty {
                            polygons.append(MLNPolygon(coordinates: polygonCoordinates, count: UInt(polygonCoordinates.count)))
                        }
                    }
                    
                    if !polygons.isEmpty {
                        // Create a polygon with the first polygon as the exterior ring
                        // and the remaining polygons as interior rings (holes)
                        let exteriorRing = polygons.removeFirst()
                        if polygons.isEmpty {
                            multiPolygons.append(exteriorRing)
                        } else {
                            let polygonWithHoles = MLNPolygon(
                                coordinates: exteriorRing.coordinates,
                                count: exteriorRing.pointCount,
                                interiorPolygons: polygons
                            )
                            multiPolygons.append(polygonWithHoles)
                        }
                    }
                }
                
                // If multi polygons is empty return nil
                guard !multiPolygons.isEmpty else {
                    return nil
                }
                
                // Return multi polygon
                return MLNMultiPolygon(polygons: multiPolygons)
            default:
                return nil
        }
    }
}
