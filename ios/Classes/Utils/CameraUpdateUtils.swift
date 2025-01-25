//
//  CameraUpdateUtils.swift
//  Pods
//
//  Created by Amit on 24/01/2025.
//

import MapLibre
import CoreLocation

//class CameraUpdateUtils {
//    /// Converts a dictionary argument to a camera update
//    static func cameraUpdateFromArgs(_ args: [String: Any?]) -> MLNCameraPosition {
//        guard let type = args["type"] as? String else {
//            fatalError("Camera update type is required")
//        }
//        
//        switch type {
//            case "newCameraPosition":
//                guard let cameraPositionArgs = args["camera_position"] as? [String: Any] else {
//                    fatalError("Camera position arguments are required")
//                }
//                
//                let builder = MLNCameraPosition.Builder()
//                
//                if let target = cameraPositionArgs["target"] as? [Double], target.count == 2 {
//                    builder.setCenterCoordinate(CLLocationCoordinate2D(latitude: target[0], longitude: target[1]))
//                }
//                
//                if let zoom = cameraPositionArgs["zoom"] as? Double {
//                    builder.setZoomLevel(zoom)
//                }
//                
//                if let bearing = cameraPositionArgs["bearing"] as? Double {
//                    builder.setBearing(bearing)
//                }
//                
//                if let tilt = cameraPositionArgs["tilt"] as? Double {
//                    builder.setPitch(tilt)
//                }
//                
//                if let padding = cameraPositionArgs["padding"] as? [Double], padding.count == 4 {
//                    // Note: MapLibre Swift might handle padding differently
//                    // You may need to adjust this based on the specific Swift SDK implementation
//                }
//                
//                let cameraPosition = builder.build()
//                return MLNCameraUpdate(cameraPosition: cameraPosition)
//                
//            case "newLatLng":
//                guard let latLng = args["latLng"] as? [Double], latLng.count == 2 else {
//                    fatalError("Invalid latitude and longitude")
//                }
//                let coordinate = CLLocationCoordinate2D(latitude: latLng[0], longitude: latLng[1])
//                return MLNCameraUpdate(centerCoordinate: coordinate)
//                
//            case "newLatLngBounds":
//                guard let bounds = args["bounds"] as? [String: Any],
//                      let northEast = bounds["northeast"] as? [Double],
//                      let southWest = bounds["southwest"] as? [Double] else {
//                    fatalError("Invalid bounds")
//                }
//                
//                let sw = CLLocationCoordinate2D(latitude: southWest[0], longitude: southWest[1])
//                let ne = CLLocationCoordinate2D(latitude: northEast[0], longitude: northEast[1])
//                
//                let padding = (bounds["padding"] as? Double) ?? 0
//                let bearing = (bounds["bearing"] as? Double) ?? 0
//                let tilt = (bounds["tilt"] as? Double) ?? 0
//                
//                // Note: The exact method might vary depending on the MapLibre Swift SDK
//                // You may need to adjust this based on the specific SDK implementation
//                return MLNCameraUpdate(bounds: MLNCoordinateBounds(sw: sw, ne: ne),
//                                       edgePadding: UIEdgeInsets(top: CGFloat(padding),
//                                                                 left: CGFloat(padding),
//                                                                 bottom: CGFloat(padding),
//                                                                 right: CGFloat(padding)))
//                
//            case "zoomTo":
//                guard let zoom = args["zoom"] as? Double else {
//                    fatalError("Zoom level is required")
//                }
//                return MLNCameraUpdate(zoomLevel: zoom)
//                
//            case "zoomBy":
//                guard let zoom = args["zoom"] as? Double else {
//                    fatalError("Zoom delta is required")
//                }
//                return MLNCameraUpdate(zoomLevelDelta: zoom)
//                
//            default:
//                fatalError("Invalid camera update type: \(type)")
//        }
//    }
//}
