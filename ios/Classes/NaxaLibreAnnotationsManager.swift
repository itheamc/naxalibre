//
//  NaxaLibreAnnotationsManager.swift
//  naxalibre
//
//  Created by Amit on 09/03/2025.
//

import Foundation
import Flutter
import MapLibre

/**
 * Manages the creation, manipulation, and storage of annotations on a MapLibre map.
 *
 * This class acts as an intermediary between the Flutter application and the underlying
 * MapLibre map view, facilitating the addition of various types of annotations like circles,
 * polyline, polygons, and symbols. It handles the conversion of data from Flutter to
 * MapLibre-compatible objects and maintains a registry of all added annotations.
 */
class NaxaLibreAnnotationsManager {
    
    // MARK: - Properties
    
    private let binaryMessenger: FlutterBinaryMessenger
    private let libreView: MLNMapView
    
    // MARK: - Initialization
    
    init(binaryMessenger: FlutterBinaryMessenger, libreView: MLNMapView) {
        self.binaryMessenger = binaryMessenger
        self.libreView = libreView
    }
    
    /**
     * Represents the different types of annotations that can be drawn on a map or image.
     *
     * Each type defines a distinct visual representation and interaction behavior:
     *
     * - **Circle:**  Represents a circular area on the map. Useful for highlighting a region or showing a radius.
     * - **Polyline:** Represents a connected series of line segments. Ideal for paths, routes, or boundaries.
     * - **Polygon:** Represents a closed shape formed by connected line segments. Suitable for areas, regions, or buildings.
     * - **Symbol:** Represents a point marker with an associated icon or text label. Used for locations, points of interest, or icons.
     */
    enum AnnotationType: String {
        case circle = "Circle"
        case polyline = "Polyline"
        case polygon = "Polygon"
        case symbol = "Symbol"
    }
    
    /**
     * Represents an annotation on a map, such as a marker, line, or polygon.
     *
     * An annotation consists of visual properties (paint), spatial properties (layout),
     * data associated with the annotation, and whether it can be dragged.
     *
     * @property id A unique identifier for the annotation.
     * @property type The type of the annotation (e.g., Marker, Line, Polygon).
     * @property layer The actual layer object representing the annotation on the map.
     * @property geometry The geometry of the annotation, such as a point, linestring, or polygon.
     * @property data A map of arbitrary key-value pairs associated with the annotation.
     *               This can be used to store custom data relevant to the annotation.
     *               Defaults to an empty map.
     * @property draggable Whether the annotation can be dragged by the user. Defaults to `false`.
     */
    struct Annotation<T: MLNStyleLayer> {
        let id: Int64
        let type: AnnotationType
        let layer: T
        let geometry: MLNShape?
        let data: [String: Any]
        let draggable: Bool
        
        // Constructor
        init(id: Int64, type: AnnotationType, layer: T, geometry: MLNShape? = nil, data: [String: Any] = [:], draggable: Bool = false) {
            self.id = id
            self.type = type
            self.layer = layer
            self.geometry = geometry
            self.data = data
            self.draggable = draggable
        }
        
        // Creates a copy of the annotation with optional modified properties.
        func copy(
            id: Int64? = nil,
            type: AnnotationType? = nil,
            layer: T? = nil,
            geometry: MLNShape? = nil,
            data: [String: Any]? = nil,
            draggable: Bool? = nil
        ) -> Annotation<T> {
            return Annotation(
                id: id ?? self.id,
                type: type ?? self.type,
                layer: layer ?? self.layer,
                geometry: geometry ?? self.geometry,
                data: data ?? self.data,
                draggable: draggable ?? self.draggable
            )
        }
        
        // Create an map from the annotation
        func toMap() -> [String: Any] {
            var map: [String: Any] = [
                "id": id,
                "type": type.rawValue,
                "data": data,
                "draggable": draggable,
                "geometry": [:]
            ]
            
            if let geoJSONData = self.geometry?.geoJSONData(usingEncoding: String.Encoding.utf8.rawValue) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: geoJSONData, options: []) as? [String: Any?] {
                        map["geometry"] = jsonObject
                    }
                } catch {
                    map["geometry"] = [:]
                }
            }

            
            return map
        }
    
    }
    
    /**
     * A list of annotations representing circles drawn on the map.
     *
     * Each [Annotation] in this list represents a single circle.
     * These annotations can be used to visualize areas of interest,
     * radius around a point, or any other circular region on the map.
     *
     * The list is mutable, meaning annotations can be added or removed dynamically.
     *
     */
    private var circleAnnotations: [Annotation<MLNCircleStyleLayer>] = []
    
    /**
     * A list of annotations that represent polylines drawn on the map.
     *
     * Each annotation in this list defines a polyline's visual representation, including:
     * - The points (coordinates) that make up the polyline.
     * - The stroke (line) color, width, and other drawing properties.
     * - Any associated metadata or identifiers.
     *
     * These annotations are typically used to visually highlight routes, boundaries,
     * or other linear features on a map. They are rendered as a sequence of connected
     * line segments.
     *
     */
    private var polylineAnnotations: [Annotation<MLNLineStyleLayer>] = []
    
    /**
     * A list of annotations representing polygons drawn on the map.
     *
     * Each [Annotation] in this list represents a single polygon.
     * These annotations are used to visualize closed areas on the map.
     *
     * Polygons are defined by a list of coordinates that form their boundaries.
     *
     */
    private var polygonAnnotations: [Annotation<MLNFillStyleLayer>] = []
    
    /**
     * A list of annotations representing symbols (markers, icons) placed on the map.
     *
     * Each [Annotation] in this list represents a single symbol.
     * These annotations are used to mark specific points of interest on the map.
     *
     * Symbols can be customized with various icons, text labels, and other visual properties.
     *
     */
    private var symbolAnnotations: [Annotation<MLNSymbolStyleLayer>] = []
    
    /**
     * A list containing all annotations currently present on the map.
     * This includes circle, polyline, polygon, and symbol annotations.
     *
     */
    var allAnnotations: [NaxaLibreAnnotationsManager.Annotation<MLNStyleLayer>] {
        return [
            self.circleAnnotations,
            self.polylineAnnotations,
            self.polygonAnnotations,
            self.symbolAnnotations
        ].compactMap { $0 as? NaxaLibreAnnotationsManager.Annotation<MLNStyleLayer> }
    }

    
    // MARK: - Methods
    
    /**
     * Adds an annotation based on the provided arguments.
     *
     * This function takes a dictionary of arguments and attempts to create an annotation of a specific type.
     * The "type" key in the dictionary is used to determine the type of annotation.
     * The function checks for a valid annotation type and throws an exception if the provided type is invalid.
     *
     * @param args A dictionary containing the arguments for creating the annotation.
     *             It is expected to have a key "type" whose value is a string
     *             representing the desired annotation type.
     *             The string should match one of the values in the `AnnotationType` enum (case-insensitive).
     *
     * @throws Exception If the annotation type provided in the `args` dictionary is invalid.
     *
     */
    func addAnnotation(args: [String: Any?]?) throws -> [String: Any?] {
        // Getting the annotation type args from the arguments
        guard let args = args else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Arguments cannot be nil"]
            )
        }
        
        guard let typeArgs = args["type"] as? String else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Type argument is required"]
            )
        }
        
        // Getting the annotation type from the type args
        let typeValue = typeArgs.prefix(1).uppercased() + typeArgs.dropFirst().lowercased()
        guard let type = AnnotationType(rawValue: typeValue) else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Invalid annotation type"]
            )
        }
        
        // Adding the annotation based on the type
        switch type {
            case .circle:
                let annotation = try addCircleAnnotation(args: args)
                return annotation.toMap()
            case .polyline:
                let annotation = try addPolylineAnnotation(args: args)
                return annotation.toMap()
            case .polygon:
                let annotation = try addPolygonAnnotation(args: args)
                return annotation.toMap()
            case .symbol:
                let annotation = try addSymbolAnnotation(args: args)
                return annotation.toMap()
        }
    }
    
    /**
     * Adds a circle annotation to the map.
     *
     * This function adds a circle to the map at a specified point with optional
     * styling and data. It handles the creation of the GeoJsonSource and CircleLayer
     * and adds them to the map's style.  It also supports updating existing circle annotations by
     * removing and re-adding them if they already exist. The function stores the created annotation
     * in the `circleAnnotations` list.
     *
     * @param args A dictionary containing the arguments for the circle annotation. It should contain the following:
     * @throws Exception if parsing arguments fails
     *
     */
    private func addCircleAnnotation(args: [String: Any?]) throws -> NaxaLibreAnnotationsManager.Annotation<MLNCircleStyleLayer> {
        guard let optionsArgs = args["options"] as? [AnyHashable: Any] else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Options argument is required"]
            )
        }
        
        guard let pointArg = optionsArgs["point"] as? [Any] else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Point argument is required"]
            )
        }
        
        let point = pointArg.compactMap { ($0 as? NSNumber)?.doubleValue }
        guard point.count >= 2 else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Point argument must be a list of two numbers"]
            )
        }
        
        // Create a point geometry
        let pointGeometry = MLNPointAnnotation()
        pointGeometry.coordinate = CLLocationCoordinate2D(latitude: point[0], longitude: point[1])
        
        // Creating Annotation as per the args
        let annotation: NaxaLibreAnnotationsManager.Annotation<MLNCircleStyleLayer> = try AnnotationArgsParser.parseArgs(args: args) { id, sourceId, layerId, draggable, data in
            
            // Removing layer if already exist
            if let layer = libreView.style?.layer(withIdentifier: layerId) {
                libreView.style?.removeLayer(layer)
            }
            
            // Removing source if already exist
            if let source = libreView.style?.source(withIdentifier: sourceId) {
                libreView.style?.removeSource(source)
            }
            
            // Creating Feature
            let feature = MLNPointFeature()
            feature.identifier = String(id)
            feature.coordinate = pointGeometry.coordinate
            
            var attributes: [String: Any] = [:]
            attributes["id"] = id
            attributes["layer"] = layerId
            attributes["type"] = NaxaLibreAnnotationsManager.AnnotationType.circle.rawValue
            attributes["draggable"] = draggable
            attributes["data"] = data
            
            let geoJSONData = pointGeometry.geoJSONData(usingEncoding:String.Encoding.utf8.rawValue)
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: geoJSONData, options: []) as? [String: Any?] {
                    attributes["geometry"] = jsonObject
                }
            } catch {
                attributes["geometry"] = [:]
            }
            
            feature.attributes = attributes
            
            // Adding source
            let source = MLNShapeSource(identifier: sourceId, features: [feature], options: nil)
            libreView.style?.addSource(source)
            
            // Returning Source
            return source
        }
        
        // Add the layer to the map
        libreView.style?.addLayer(annotation.layer)
        
        // Updated Annotation
        let updatedAnnotation = annotation.copy(geometry: pointGeometry)
        
        // Append to circle annotations list
        circleAnnotations.append(updatedAnnotation)
        
        // Return annotation
        return updatedAnnotation
    }
    
    /**
     * Adds a polyline annotation to the map.
     *
     * This function takes a dictionary of arguments, extracts the necessary data to define a polyline,
     * and then adds it as an annotation to the Mapbox map. The polyline is represented by a
     * sequence of geographic points. The function also supports custom data and draggable
     * properties for the polyline. It handles the addition and removal of layers and sources
     * if they already exist to avoid duplicates.
     *
     * @param args A dictionary containing the necessary arguments for creating the polyline annotation.
     * @throws Exception if parsing arguments fails
     *
     */
    private func addPolylineAnnotation(args: [String: Any?]) throws -> NaxaLibreAnnotationsManager.Annotation<MLNLineStyleLayer> {
        guard let optionsArgs = args["options"] as? [AnyHashable: Any] else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Options argument is required"]
            )
        }
        
        guard let pointsArg = optionsArgs["points"] as? [Any] else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Points argument is required"]
            )
        }
        
        var coordinates: [CLLocationCoordinate2D] = []
        for points in pointsArg as! [[Any]] {
            guard points.count >= 2,
                  let lat = points[0] as? Double,
                  let lng = points[1] as? Double else {
                continue
            }
            coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
        }
        
        guard !coordinates.isEmpty else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400, userInfo: [NSLocalizedDescriptionKey: "Points argument must be a list of list double"]
            )
        }
        
        // Create a polyline geometry
        let polyline = MLNPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        
        // Creating Annotation as per the args
        let annotation: NaxaLibreAnnotationsManager.Annotation<MLNLineStyleLayer> = try AnnotationArgsParser.parseArgs(args: args) { id, sourceId, layerId, draggable, data in
            
            // Removing layer if already exist
            if let layer = libreView.style?.layer(withIdentifier: layerId) {
                libreView.style?.removeLayer(layer)
            }
            
            // Removing source if already exist
            if let source = libreView.style?.source(withIdentifier: sourceId) {
                libreView.style?.removeSource(source)
            }
            
            // Creating Feature
            let feature = MLNPolylineFeature(coordinates: polyline.coordinates, count: polyline.pointCount)
            feature.identifier = String(id)
            
            var attributes: [String: Any] = [:]
            attributes["id"] = id
            attributes["layer"] = layerId
            attributes["type"] = NaxaLibreAnnotationsManager.AnnotationType.polyline.rawValue
            attributes["draggable"] = draggable
            attributes["data"] = data
            
            let geoJSONData = polyline.geoJSONData(usingEncoding:String.Encoding.utf8.rawValue)
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: geoJSONData, options: []) as? [String: Any?] {
                    attributes["geometry"] = jsonObject
                }
            } catch {
                attributes["geometry"] = [:]
            }
            
            feature.attributes = attributes
            
            // Adding source
            let source = MLNShapeSource(identifier: sourceId, features: [feature], options: nil)
            libreView.style?.addSource(source)
            
            return source
        }
        
        // Add the layer to the map
        libreView.style?.addLayer(annotation.layer)
        
        // Updated Annotation
        let updatedAnnotation = annotation.copy(geometry: polyline)
        
        // Append to polyline annotations list
        polylineAnnotations.append(updatedAnnotation)
        
        // Return Annotation
        return updatedAnnotation
    }
    
    /**
     * Adds a polygon annotation to the map.
     *
     * This function takes a dictionary of arguments to define the polygon's properties,
     * including its vertices, associated data, and draggable state. It creates
     * a new polygon layer on the map using the provided information. If a layer or source with the same id
     * already exists it will remove it before add the new one.
     *
     * @param args A dictionary containing the arguments for the polygon annotation.
     * @throws Exception if parsing arguments fails
     *
     */
    private func addPolygonAnnotation(args: [String: Any?]) throws -> NaxaLibreAnnotationsManager.Annotation<MLNFillStyleLayer> {
        guard let optionsArgs = args["options"] as? [AnyHashable: Any] else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Options argument is required"]
            )
        }
        
        guard let pointsArg = optionsArgs["points"] as? [Any] else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Points argument is required"]
            )
        }
        
        var polygonCoordinates: [[CLLocationCoordinate2D]] = []
        
        for ring in pointsArg {
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
        
        guard !polygonCoordinates.isEmpty else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Points argument must be a list of list double"]
            )
        }
        
        // Create polygon geometries
        // For simplicity, we'll assume there's only one ring of coordinates
        guard let coordinates = polygonCoordinates.first else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Invalid polygon coordinates"]
            )
        }
        
        // Create a polygon geometry
        let polygon = MLNPolygon(coordinates: coordinates, count: UInt(coordinates.count))
        
        // Creating Annotation as per the args
        let annotation: NaxaLibreAnnotationsManager.Annotation<MLNFillStyleLayer> = try AnnotationArgsParser.parseArgs(args: args) { id, sourceId, layerId, draggable, data in
            
            // Removing layer if already exist
            if let layer = libreView.style?.layer(withIdentifier: layerId) {
                libreView.style?.removeLayer(layer)
            }
            
            // Removing source if already exist
            if let source = libreView.style?.source(withIdentifier: sourceId) {
                libreView.style?.removeSource(source)
            }
            
            // Creating Feature
            let feature = MLNPolygonFeature(coordinates: polygon.coordinates, count: polygon.pointCount)
            feature.identifier = String(id)
            
            var attributes: [String: Any] = [:]
            attributes["id"] = id
            attributes["layer"] = layerId
            attributes["type"] = NaxaLibreAnnotationsManager.AnnotationType.polygon.rawValue
            attributes["draggable"] = draggable
            attributes["data"] = data
            
            let geoJSONData = polygon.geoJSONData(usingEncoding:String.Encoding.utf8.rawValue)
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: geoJSONData, options: []) as? [String: Any?] {
                    attributes["geometry"] = jsonObject
                }
            } catch {
                attributes["geometry"] = [:]
            }
            
            feature.attributes = attributes
            
            // Adding source
            let source = MLNShapeSource(identifier: sourceId, features: [feature], options: nil)
            libreView.style?.addSource(source)
            
            return source
        }
        
        // Add the layer to the map
        libreView.style?.addLayer(annotation.layer)
        
        // Updated Annotation
        let updatedAnnotation = annotation.copy(geometry: polygon)
        
        // Append to polygon annotations list
        polygonAnnotations.append(updatedAnnotation)
        
        // Return Annotation
        return updatedAnnotation
    }
    
    /**
     * Adds a symbol annotation to the map.
     *
     * This function takes a dictionary of arguments, extracts necessary information,
     * constructs a symbol annotation object, and adds it to the map's style.
     * It handles creating or updating the necessary source and layer for the
     * annotation and manages a collection of all symbol annotations.
     *
     * @param args A dictionary containing the arguments for the symbol annotation.
     * @throws Exception Throws an exception if:
     *   - The "point" argument is missing.
     *   - The "point" argument is not a list of two numbers.
     *
     */
    private func addSymbolAnnotation(args: [String: Any?]) throws -> NaxaLibreAnnotationsManager.Annotation<MLNSymbolStyleLayer> {
        guard let optionsArgs = args["options"] as? [AnyHashable: Any] else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Options argument is required"]
            )
        }
        
        guard let pointArg = optionsArgs["point"] as? [Any] else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Point argument is required"]
            )
        }
        
        let point = pointArg.compactMap { ($0 as? NSNumber)?.doubleValue }
        guard point.count >= 2 else {
            throw NSError(
                domain: "NaxaLibreAnnotationsManager",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Point argument must be a list of two numbers"]
            )
        }
        
        // Create a point geometry
        let pointGeometry = MLNPointAnnotation()
        pointGeometry.coordinate = CLLocationCoordinate2D(latitude: point[0], longitude: point[1])
        
        // Creating Annotation as per the args
        let annotation: NaxaLibreAnnotationsManager.Annotation<MLNSymbolStyleLayer> = try AnnotationArgsParser.parseArgs(args: args) { id, sourceId, layerId, draggable, data in
            
            // Removing layer if already exist
            if let layer = libreView.style?.layer(withIdentifier: layerId) {
                libreView.style?.removeLayer(layer)
            }
            
            // Removing source if already exist
            if let source = libreView.style?.source(withIdentifier: sourceId) {
                libreView.style?.removeSource(source)
            }
            
            // Creating Feature
            let feature = MLNPointFeature()
            feature.identifier = String(id)
            feature.coordinate = pointGeometry.coordinate
            
            var attributes: [String: Any] = [:]
            attributes["id"] = id
            attributes["layer"] = layerId
            attributes["type"] = NaxaLibreAnnotationsManager.AnnotationType.symbol.rawValue
            attributes["draggable"] = draggable
            attributes["data"] = data
            
            let geoJSONData = pointGeometry.geoJSONData(usingEncoding:String.Encoding.utf8.rawValue)
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: geoJSONData, options: []) as? [String: Any?] {
                    attributes["geometry"] = jsonObject
                }
            } catch {
                attributes["geometry"] = [:]
            }
            
            feature.attributes = attributes
            
            // Adding source
            let source = MLNShapeSource(identifier: sourceId, features: [feature], options: nil)
            libreView.style?.addSource(source)
            
            return source
        }
        
        // Add the layer to the map
        libreView.style?.addLayer(annotation.layer)
        
        // Updated Annotation
        let updatedAnnotation = annotation.copy(geometry: pointGeometry)
        
        // Append to symbol annotations list
        symbolAnnotations.append(updatedAnnotation)
        
        // Return Annotation
        return updatedAnnotation
    }
}
