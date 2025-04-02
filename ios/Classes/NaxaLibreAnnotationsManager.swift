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
class NaxaLibreAnnotationsManager: NSObject {
    
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
        
        var list: [NaxaLibreAnnotationsManager.Annotation<MLNStyleLayer>] = []
        
        list.append(contentsOf: self.circleAnnotations.compactMap {
            NaxaLibreAnnotationsManager.Annotation(
                id: $0.id,
                type: $0.type,
                layer: $0.layer,
                geometry: $0.geometry,
                data: $0.data,
                draggable: $0.draggable
            )
        })
        
        list.append(contentsOf: self.polylineAnnotations.compactMap {
            NaxaLibreAnnotationsManager.Annotation(
                id: $0.id,
                type: $0.type,
                layer: $0.layer,
                geometry: $0.geometry,
                data: $0.data,
                draggable: $0.draggable
            )
        })
        
        list.append(contentsOf: self.polygonAnnotations.compactMap {
            NaxaLibreAnnotationsManager.Annotation(
                id: $0.id,
                type: $0.type,
                layer: $0.layer,
                geometry: $0.geometry,
                data: $0.data,
                draggable: $0.draggable
            )
        })
        
        list.append(contentsOf: self.symbolAnnotations.compactMap {
            NaxaLibreAnnotationsManager.Annotation(
                id: $0.id,
                type: $0.type,
                layer: $0.layer,
                geometry: $0.geometry,
                data: $0.data,
                draggable: $0.draggable
            )
        })
        
        return list
    }
    
    /**
     * The annotation currently being dragged by the user.
     *
     * Holds a reference to the `Annotation` instance that is actively being manipulated
     * (dragged) by the user. If no annotation is being dragged, this property is `nil`.
     *
     * This is essential for tracking user interactions, such as updating an annotation's
     * position during a drag gesture or triggering actions when the drag ends.
     *
     * The generic type `T` allows this property to store instances of any `Annotation` subclass.
     */
    private var draggingAnnotation: NaxaLibreAnnotationsManager.Annotation? = nil
    
    /**
     * Tracks whether the map annotation drag gesture recognizer has been initialized.
     *
     * - Used to ensure we only add the drag gesture recognizer once to avoid conflicts.
     * - Set to `true` after successfully adding the UIPanGestureRecognizer to the map view.
     * - Reset to `false` when cleaning up gesture recognizers.
     */
    private var isDragListenerAlreadyAdded: Bool = false
    
    /**
     * The last known / starting coordinate of the most recent drag interaction.
     *
     * - Stores the starting position when a user starts dragging an annotation.
     * - Persists between drag sessions until explicitly cleared.
     * - Used to compare against new coordinates.
     *
     * Note: Reset to nil on drag end or cancel.
     */
    private var lastCoordinate: CLLocationCoordinate2D? = nil

    
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
    
    /**
     * Deletes an annotation from the map based on the provided arguments.
     *
     * This function removes a specific annotation (Circle, Polyline, Polygon, or Symbol)
     * from the map's style and the corresponding annotation list. It requires the
     * annotation's unique ID and its type to perform the deletion.
     *
     * @param args A dictionary containing the arguments required for deleting the annotation.
     *             It should include the following key-value pairs:
     *             - "id": (Int64) The unique identifier of the annotation to be deleted.
     *             - "type": (String) The type of the annotation (e.g., "Circle", "Polyline", "Polygon", "Symbol").
     *
     * @throws An error if:
     *             - The `args` dictionary is nil.
     *             - The "id" argument is missing or is not an Int64.
     *             - The "type" argument is missing or is not a valid AnnotationType.
     *             - Any issue occurs when removing layer or source from style.
     *
     */
    func deleteAnnotation(args: [AnyHashable: Any]?) throws {
        guard let args = args else {
            throw NSError(domain: "NaxaLibreAnnotationsManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid arguments"])
        }
        
        // Getting the id of the annotation
        guard let id = args["id"] as? Int64 else {
            throw NSError(domain: "NaxaLibreAnnotationsManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Id argument is required"])
        }
        
        // Getting the annotation type args from the arguments
        guard let typeArgs = args["type"] as? String else {
            throw NSError(domain: "NaxaLibreAnnotationsManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Annotation type argument is required"])
        }
        
        // Getting the annotation type from the type args
        let typeString = typeArgs.prefix(1).capitalized + typeArgs.dropFirst()
        guard let type = AnnotationType(rawValue: typeString) else {
            throw NSError(domain: "NaxaLibreAnnotationsManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid annotation type: \(typeArgs)"])
        }
        
        // Handling delete as per type
        switch type {
            case .circle:
                if let index = circleAnnotations.firstIndex(where: { $0.id == id }) {
                    let annotation = circleAnnotations[index]
                    libreView.style?.removeLayer(annotation.layer)
                    
                    if let sourceId = annotation.layer.sourceIdentifier, let source = libreView.style?.source(withIdentifier: sourceId) {
                        libreView.style?.removeSource(source)
                    }
                    
                    circleAnnotations.remove(at: index)
                }
                
            case .polyline:
                if let index = polylineAnnotations.firstIndex(where: { $0.id == id }) {
                    let annotation = polylineAnnotations[index]
                    libreView.style?.removeLayer(annotation.layer)
                    
                    if let sourceId = annotation.layer.sourceIdentifier, let source = libreView.style?.source(withIdentifier: sourceId) {
                        libreView.style?.removeSource(source)
                    }
                    
                    polylineAnnotations.remove(at: index)
                }
                
            case .polygon:
                if let index = polygonAnnotations.firstIndex(where: { $0.id == id }) {
                    let annotation = polygonAnnotations[index]
                    libreView.style?.removeLayer(annotation.layer)
                    
                    if let sourceId = annotation.layer.sourceIdentifier, let source = libreView.style?.source(withIdentifier: sourceId) {
                        libreView.style?.removeSource(source)
                    }
                    
                    polygonAnnotations.remove(at: index)
                }
                
            case .symbol:
                if let index = symbolAnnotations.firstIndex(where: { $0.id == id }) {
                    let annotation = symbolAnnotations[index]
                    libreView.style?.removeLayer(annotation.layer)
                    
                    if let sourceId = annotation.layer.sourceIdentifier, let source = libreView.style?.source(withIdentifier: sourceId) {
                        libreView.style?.removeSource(source)
                    }
                    
                    symbolAnnotations.remove(at: index)
                }
        }
    }
    
    /**
     * Deletes all annotations of a specified type.
     * @param args A dictionary containing the annotation type to be deleted
     * @throws An error when arguments are invalid or the annotation type is missing or invalid
     */
    func deleteAllAnnotations(args: [AnyHashable: Any]?) throws {
        guard let args = args else {
            throw NSError(domain: "InvalidArguments", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid arguments"])
        }
        
        // Extract and validate annotation type
        guard let typeArgs = args["type"] as? String else {
            throw NSError(domain: "MissingTypeArgument", code: -1, userInfo: [NSLocalizedDescriptionKey: "Annotation type argument is required"])
        }
        
        // Convert type string to enum with proper error handling
        let typeString = typeArgs.prefix(1).capitalized + typeArgs.dropFirst()
        guard let type = AnnotationType(rawValue: typeString) else {
            throw NSError(domain: "InvalidAnnotationType", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid annotation type: \(typeString)"])
        }
        
        // Delete annotations as per type
        switch type {
            case .circle:
                let annotations = circleAnnotations
                
                // Use a reversed loop to avoid index issues during removal
                for i in (0..<annotations.count).reversed() {
                    let annotation = annotations[i]
                    
                    // Remove layer and source
                    libreView.style?.removeLayer(annotation.layer)
                    
                    // Remove source
                    if let sourceId = annotation.layer.sourceIdentifier, let source = libreView.style?.source(withIdentifier: sourceId) {
                        libreView.style?.removeSource(source)
                    }
                    
                    // Remove from the correct collection based on type
                    circleAnnotations.remove(at: i)
                }
            case .polyline:
                let annotations = polylineAnnotations
                
                // Use a reversed loop to avoid index issues during removal
                for i in (0..<annotations.count).reversed() {
                    let annotation = annotations[i]
                    
                    // Remove layer and source
                    libreView.style?.removeLayer(annotation.layer)
                    
                    // Remove source
                    if let sourceId = annotation.layer.sourceIdentifier, let source = libreView.style?.source(withIdentifier: sourceId) {
                        libreView.style?.removeSource(source)
                    }
                    
                    // Remove from the correct collection based on type
                    polylineAnnotations.remove(at: i)
                }
            case .polygon:
                let annotations = polygonAnnotations
                
                // Use a reversed loop to avoid index issues during removal
                for i in (0..<annotations.count).reversed() {
                    let annotation = annotations[i]
                    
                    // Remove layer and source
                    libreView.style?.removeLayer(annotation.layer)
                    
                    // Remove source
                    if let sourceId = annotation.layer.sourceIdentifier, let source = libreView.style?.source(withIdentifier: sourceId) {
                        libreView.style?.removeSource(source)
                    }
                    
                    // Remove from the correct collection based on type
                    polygonAnnotations.remove(at: i)
                }
            case .symbol:
                let annotations = symbolAnnotations
                
                // Use a reversed loop to avoid index issues during removal
                for i in (0..<annotations.count).reversed() {
                    let annotation = annotations[i]
                    
                    // Remove layer and source
                    libreView.style?.removeLayer(annotation.layer)
                    
                    // Remove source
                    if let sourceId = annotation.layer.sourceIdentifier, let source = libreView.style?.source(withIdentifier: sourceId) {
                        libreView.style?.removeSource(source)
                    }
                    
                    // Remove from the correct collection based on type
                    symbolAnnotations.remove(at: i)
                }
        }
    }
}


extension NaxaLibreAnnotationsManager {
    // MARK: - Annotation Handling
    
    /**
     * Checks if an annotation exists at a given coordinate on the map.
     *
     * This function queries the rendered features on the map at the screen location
     * corresponding to the provided coordinate. It then checks if any of the found features
     * belong to the annotation layers managed by the libreAnnotationsManager.
     * If a feature is found and it has an "id" property, it's considered an annotation.
     *
     * @param point The screen coordinate (x and y) to check for annotations.
     * @return A tuple:
     *         - First element (Bool): True if an annotation is found at the given coordinate, false otherwise.
     *         - Second element ([String: Any]?): The properties of the first annotation found at the given coordinate, or nil if no annotation is found.
     */
    func isAnnotationAtPoint(_ point: CGPoint) -> (Bool, [String: Any]?) {
        
        let layerIds = allAnnotations.compactMap { $0.layer.identifier }
        
        let features = libreView.visibleFeatures(at: point, styleLayerIdentifiers: Set(layerIds))
        
        if let firstFeature = features.first {
            let properties = firstFeature.attributes
            let hasId = properties["id"] != nil
            return (hasId, properties)
        }
        
        return (false, nil)
    }
    
    /**
     * Checks if a given dictionary represents a draggable element.
     *
     * This function attempts to extract the value of the "draggable" key from the provided dictionary.
     * If the key exists and its value is a boolean `true`, the function returns `true`.
     * If the key is missing, the value is not a boolean, or any exception occurs during the process,
     * the function returns `false`.
     *
     * @param properties The dictionary to check. Can be `nil`.
     * @return `true` if the dictionary has a "draggable" key with a value of `true`, `false` otherwise.
     */
    func isDraggable(_ properties: [String: Any]?) -> Bool {
        guard let properties = properties else { return false }
        return (properties["draggable"] as? Bool) == true
    }
    
    /**
     * Handles the start of a dragging operation for a specific annotation.
     *
     * This function takes a dictionary containing annotation properties, extracts the annotation's ID,
     * and sets up the necessary state to track the dragging annotation.
     *
     * @param properties A dictionary containing properties of the annotation that is being dragged.
     * It is expected to have a property named "id" representing the unique identifier of the annotation.
     */
    func handleDragging(_ properties: [String: Any]) {
        // Parse the annotation id from properties
        guard let annotationId = properties["id"] as? Int64 else { return }
        
        // Find the annotation from the all added annotations by id
        draggingAnnotation = allAnnotations.first {$0.id == annotationId}
        
        // Add the drag listener
        addAnnotationDragListener()
    }
    
    /**
     * Adds a touch listener to the `libreView` to handle dragging of annotations on the map.
     */
    private func addAnnotationDragListener() {
        if isDragListenerAlreadyAdded { return }
        
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragGesture(_:)))
        
        dragGesture.delegate = self
        libreView.addGestureRecognizer(dragGesture)
        isDragListenerAlreadyAdded = true
    }
    
    
    @objc private func handleDragGesture(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: libreView)
        let currentCoordinate = libreView.convert(point, toCoordinateFrom: nil)
        
        switch gesture.state {
            case .began:
                lastCoordinate = currentCoordinate
                
            case .changed:
                if let annotation = draggingAnnotation {
                    
                    if annotation.type == .circle || annotation.type == .symbol {
                        handlePointDrag(currentCoordinate, geometry: annotation.geometry)
                    } else if annotation.type == .polyline {
                        if let lineString = annotation.geometry as? MLNPolyline {
                            guard let lastCoordinate = lastCoordinate else { return }
                            handleLineDrag(currentCoordinate, lastCoordinate: lastCoordinate, geometry: lineString)
                        }
                    } else if annotation.type == .polygon {
                        if let polygon = annotation.geometry as? MLNPolygon {
                            guard let lastCoordinate = lastCoordinate else { return }
                            handlePolygonDrag(currentCoordinate, lastCoordinate: lastCoordinate, geometry: polygon)
                        }
                    }

                }
            case .ended, .cancelled:
                draggingAnnotation = nil
                lastCoordinate = nil
                
            default:
                break
        }
    }
    
    /**
     * Handles the dragging of a point annotation on the map.
     *
     * @param currentCoordinate The new coordinate representing the current position of the drag.
     * @param geometry The original geometry of the annotation being dragged.
     */
    private func handlePointDrag(_ currentCoordinate: CLLocationCoordinate2D, geometry: MLNShape?) {
        guard let point = geometry as? MLNPointAnnotation else { return }
        
        point.coordinate = currentCoordinate
        
        if let annotation = draggingAnnotation {
            let updated = annotation.copy(geometry: point)
            if updated.type == .circle {
                updateCircleAnnotation(updated, newGeometry: point)
            } else {
                updateSymbolAnnotation(updated, newGeometry: point)
            }
        }
    }
    
    /**
     * Handles the dragging of a line (LineString) on the map.
     *
     * @param currentCoordinate The current coordinate where the drag is occurring.
     * @param lastCoordinate The previous coordinate where the drag occurred.
     * @param geometry The original geometry being dragged.
     */
    private func handleLineDrag(_ currentCoordinate: CLLocationCoordinate2D, lastCoordinate: CLLocationCoordinate2D, geometry: MLNPolyline) {
        // Calculate the delta between current and previous positions
        let deltaLng = currentCoordinate.longitude - lastCoordinate.longitude
        let deltaLat = currentCoordinate.latitude - lastCoordinate.latitude
        
        // Update all points in the line by applying the delta
        var updatedCoordinates: [CLLocationCoordinate2D] = []
        for i in 0..<geometry.pointCount {
            var coordinate = geometry.coordinates[Int(i)]
            coordinate.longitude += deltaLng
            coordinate.latitude += deltaLat
            updatedCoordinates.append(coordinate)
        }
        
        let newLineString = MLNPolyline(coordinates: updatedCoordinates, count: UInt(updatedCoordinates.count))
        
        if let annotation = draggingAnnotation {
            let updated = annotation.copy(geometry: newLineString)
            updatePolylineAnnotation(updated, newGeometry: newLineString)
        }
    }
    
    /**
     * Handles the dragging of a polygon on the map.
     *
     * @param currentCoordinate The current coordinate where the drag is occurring.
     * @param lastCoordinate The previous coordinate where the drag occurred.
     * @param geometry The Polygon geometry that is being dragged.
     */
    private func handlePolygonDrag(_ currentCoordinate: CLLocationCoordinate2D, lastCoordinate: CLLocationCoordinate2D, geometry: MLNPolygon) {
        // Calculate the delta between current and previous positions
        let deltaLng = currentCoordinate.longitude - lastCoordinate.longitude
        let deltaLat = currentCoordinate.latitude - lastCoordinate.latitude
        
        // Update all points in the polygon by applying the delta
        var updatedCoordinates: [CLLocationCoordinate2D] = []
        for i in 0..<geometry.pointCount {
            var coordinate = geometry.coordinates[Int(i)]
            coordinate.longitude += deltaLng
            coordinate.latitude += deltaLat
            updatedCoordinates.append(coordinate)
        }
        
        let newPolygon = MLNPolygon(coordinates: updatedCoordinates, count: UInt(updatedCoordinates.count))
        
        if let annotation = draggingAnnotation {
            let updated = annotation.copy(geometry: newPolygon)
            updatePolygonAnnotation(updated, newGeometry: newPolygon)
        }
    }
    
    /**
     * Updates an existing circle annotation's geometry and replaces it in the internal list.
     *
     * @param updated The updated annotation object.
     * @param newGeometry The new coordinate as a point where the circle annotation should be located.
     */
    private func updateCircleAnnotation(_ updated: NaxaLibreAnnotationsManager.Annotation<MLNStyleLayer>, newGeometry: MLNPointAnnotation) {
        guard let index = circleAnnotations.firstIndex(where: { $0.id == updated.id }),
              let circleLayer = updated.layer as? MLNCircleStyleLayer else {
            return
        }
        
        let newCircleAnnotation = NaxaLibreAnnotationsManager.Annotation<MLNCircleStyleLayer>(
            id: updated.id,
            type: updated.type,
            layer: circleLayer,
            geometry: updated.geometry,
            data: updated.data,
            draggable: updated.draggable
        )
        
        circleAnnotations.remove(at: index)
        circleAnnotations.insert(newCircleAnnotation, at: index)
        updateAnnotationSource(updated.layer, newGeometry: newGeometry)
    }
    
    /**
     * Updates an existing symbol annotation in the internal list and its source data.
     *
     * @param updated The updated annotation object.
     * @param newGeometry The new point geometry.
     */
    private func updateSymbolAnnotation(_ updated: NaxaLibreAnnotationsManager.Annotation<MLNStyleLayer>, newGeometry: MLNPointAnnotation) {
        guard let index = symbolAnnotations.firstIndex(where: { $0.id == updated.id }),
              let symbolLayer = updated.layer as? MLNSymbolStyleLayer else {
            return
        }
        
        let newSymbolAnnotation = NaxaLibreAnnotationsManager.Annotation<MLNSymbolStyleLayer>(
            id: updated.id,
            type: updated.type,
            layer: symbolLayer,
            geometry: updated.geometry,
            data: updated.data,
            draggable: updated.draggable
        )
        
        symbolAnnotations.remove(at: index)
        symbolAnnotations.insert(newSymbolAnnotation, at: index)
        updateAnnotationSource(updated.layer, newGeometry: newGeometry)
    }
    
    /**
     * Updates a polyline annotation in the `polylineAnnotations` list and its associated source.
     *
     * @param updated The updated annotation object.
     * @param newGeometry The new LineString geometry.
     */
    private func updatePolylineAnnotation(_ updated: NaxaLibreAnnotationsManager.Annotation<MLNStyleLayer>, newGeometry: MLNPolyline) {
        guard let index = polylineAnnotations.firstIndex(where: { $0.id == updated.id }),
              let polylineLayer = updated.layer as? MLNLineStyleLayer else {
            return
        }
        
        let newPolylineAnnotation = NaxaLibreAnnotationsManager.Annotation<MLNLineStyleLayer>(
            id: updated.id,
            type: updated.type,
            layer: polylineLayer,
            geometry: updated.geometry,
            data: updated.data,
            draggable: updated.draggable
        )
        
        polylineAnnotations.remove(at: index)
        polylineAnnotations.insert(newPolylineAnnotation, at: index)
        updateAnnotationSource(updated.layer, newGeometry: newGeometry)
    }
    
    /**
     * Updates a polygon annotation in the `polygonAnnotations` list and its corresponding data source.
     *
     * @param updated The updated annotation object.
     * @param newGeometry The new Polygon geometry.
     */
    private func updatePolygonAnnotation(_ updated: NaxaLibreAnnotationsManager.Annotation<MLNStyleLayer>, newGeometry: MLNPolygon) {
        guard let index = polygonAnnotations.firstIndex(where: { $0.id == updated.id }),
              let polygonLayer = updated.layer as? MLNFillStyleLayer else {
            return
        }
        
        let newPolygonAnnotation = NaxaLibreAnnotationsManager.Annotation<MLNFillStyleLayer>(
            id: updated.id,
            type: updated.type,
            layer: polygonLayer,
            geometry: updated.geometry,
            data: updated.data,
            draggable: updated.draggable
        )
        
        polygonAnnotations.remove(at: index)
        polygonAnnotations.insert(newPolygonAnnotation, at: index)
        updateAnnotationSource(updated.layer, newGeometry: newGeometry)
    }
    
    /**
     * Updates the source of a given layer with a new geometry and associated properties.
     *
     * @param layer The layer to update.
     * @param newGeometry The new geometry to be associated with the feature.
     */
    private func updateAnnotationSource(_ layer: MLNStyleLayer, newGeometry: MLNShape) {
        guard let sourceId: String = {
            if let circleLayer = layer as? MLNCircleStyleLayer {
                return circleLayer.sourceIdentifier
            } else if let symbolLayer = layer as? MLNSymbolStyleLayer {
                return symbolLayer.sourceIdentifier
            } else if let lineLayer = layer as? MLNLineStyleLayer {
                return lineLayer.sourceIdentifier
            } else if let fillLayer = layer as? MLNFillStyleLayer {
                return fillLayer.sourceIdentifier
            }
            return nil
        }() else { return }
        
        guard let source = libreView.style?.source(withIdentifier: sourceId) as? MLNShapeSource else { return }
        
        var properties: [String: Any] = [:]
        if let annotation = draggingAnnotation {
            properties = annotation.toMap()
        }
        
        let feature: MLNShape & MLNFeature
        if let point = newGeometry as? MLNPointAnnotation {
            let pointFeature = MLNPointFeature()
            pointFeature.coordinate = point.coordinate
            pointFeature.attributes = properties
            feature = pointFeature
        } else if let polyline = newGeometry as? MLNPolyline {
            let lineFeature = MLNPolylineFeature(coordinates: polyline.coordinates, count: polyline.pointCount)
            lineFeature.attributes = properties
            feature = lineFeature
        } else if let polygon = newGeometry as? MLNPolygon {
            let polygonFeature = MLNPolygonFeature(coordinates: polygon.coordinates, count: polygon.pointCount)
            polygonFeature.attributes = properties
            feature = polygonFeature
        } else {
            return
        }
        
        source.shape = feature
    }
}

// MARK: - UIGestureRecognizerDelegate
extension NaxaLibreAnnotationsManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return draggingAnnotation == nil
    }
}
