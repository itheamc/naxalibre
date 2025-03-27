//
//  AnnotationArgsParser.swift
//  naxalibre
//
//  Created by Amit on 09/03/2025.
//

import Foundation
import MapLibre

/**
 * `AnnotationArgsParser` is a utility class that provides functionality for creating and configuring
 * MapLibre GL annotations from a dictionary of arguments. It supports various annotation types including symbol,
 * polygon, polyline and circle annotations.
 *
 * This class contains the main function parseArgs used to generate a layer.
 * It also contains helper functions to convert the layer properties and transitions from
 * the provided arguments.
 */
class AnnotationArgsParser {
    
    /// Parses the provided arguments and creates an annotation of the specified layer type.
    ///
    /// - Parameters:
    ///   - args: A dictionary containing the arguments used to configure the annotation.
    ///           It should include a `"sourceId"` key with a `String` value.
    ///   - sourceProvider: A closure that takes a  `id`, `sourceId`, `layerId`, `draggable` and `data` (Int64, String, String, Bool, [String: Any]) and returns an `MLNSource`.
    ///                     This allows dynamic creation of a source based on the provided `sourceId`.
    ///
    /// - Throws: An error if the required `sourceId` is missing or if parsing fails.
    ///
    /// - Returns: An `Annotation<T>` instance associated with the specified `MLNStyleLayer`.
    ///
    static func parseArgs<T: MLNStyleLayer>(args: [String: Any?]?, sourceProvider: (Int64, String, String, Bool, [String: Any]) -> MLNSource) throws -> NaxaLibreAnnotationsManager.Annotation<T> {
        // Getting the annotation type args from the arguments
        guard let typeArgs = args?["type"] as? String else {
            throw NSError(domain: "com.naxalibre", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing annotation type"])
        }
        
        // Getting the annotation type from the type args
        let typeString = typeArgs.prefix(1).uppercased() + typeArgs.dropFirst().lowercased()
        guard let type = NaxaLibreAnnotationsManager.AnnotationType(rawValue: typeString) else {
            throw NSError(domain: "com.naxalibre", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid annotation type"])
        }
        
        // Creating random annotation id
        let id = IdUtils.rand5() + IdUtils.rand4()
        
        // Creating layerId based on generated id
        let layerId = "libre_annotation_layer_\(id)"
        
        // Creating source id based on generated id
        let sourceId = "libre_annotation_source_\(id)"
        
        // Getting the annotation properties from the arguments
        let annotationOptions = args?["options"] as? [AnyHashable: Any]
        
        // Getting the paint properties from the annotation options
        let paintArgs = annotationOptions?["paint"] as? [AnyHashable: Any]
        
        // Getting the layout properties from the annotation options
        let layoutArgs = annotationOptions?["layout"] as? [AnyHashable: Any]
        
        // Getting the transition properties from the annotation options
        let transitionsArgs = annotationOptions?["transition"] as? [AnyHashable: Any]
        
        // Getting the draggable
        let draggable = annotationOptions?["draggable"] as? Bool ?? false
        
        // Getting data
        let data = (annotationOptions?["data"] as? [AnyHashable: Any])?.reduce(into: [String: Any]()) { result, entry in
            if let key = entry.key as? String {
                result[key] = entry.value
            }
        } ?? [:]
        
        // Getting source from the source provider
        let source = sourceProvider(id, sourceId, layerId, draggable, data)
        
        // Creating Properties
        var properties: [String: Any?] = [
            "paint": paintArgs,
            "layout": layoutArgs,
            "transition": transitionsArgs
        ]
        
        // Creating the layer based on the type
        let layer: MLNStyleLayer
        
        switch type {
            case NaxaLibreAnnotationsManager.AnnotationType.symbol:
                var modifiedLayoutArgs = layoutArgs != nil ? layoutArgs! : [:]
                if let iconImage = annotationOptions?["icon-image"] {
                    modifiedLayoutArgs["icon-image"] = "\(iconImage)"
                }
                
                properties["layout"] = modifiedLayoutArgs
                
                let symbolLayer = MLNSymbolStyleLayer(identifier: layerId, source: source)
                    .configureLayoutArgs(properties)
                    .configurePaintArgs(properties)
                    .configureTransitionArgs(properties)
                
                layer = symbolLayer
                
            case NaxaLibreAnnotationsManager.AnnotationType.polygon:
                let fillLayer = MLNFillStyleLayer(identifier: layerId, source: source)
                    .configureLayoutArgs(properties)
                    .configurePaintArgs(properties)
                    .configureTransitionArgs(properties)
                
                layer = fillLayer
                
            case NaxaLibreAnnotationsManager.AnnotationType.polyline:
                let lineLayer = MLNLineStyleLayer(identifier: layerId, source: source)
                    .configureLayoutArgs(properties)
                    .configurePaintArgs(properties)
                    .configureTransitionArgs(properties)
                
                layer = lineLayer
                
            case NaxaLibreAnnotationsManager.AnnotationType.circle:
                let circleLayer = MLNCircleStyleLayer(identifier: layerId, source: source)
                    .configureLayoutArgs(properties)
                    .configurePaintArgs(properties)
                    .configureTransitionArgs(properties)
                
                layer = circleLayer
        }
        
        return NaxaLibreAnnotationsManager.Annotation(
            id: id,
            type: type,
            layer: layer as! T,
            data: data,
            draggable: draggable
        )
    }
}
