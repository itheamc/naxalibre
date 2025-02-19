//
//  NaxaLibreController.swift
//  naxalibre
//
//  Created by Amit on 24/01/2025.
//
import Foundation
import Flutter
import MapLibre

class NaxaLibreController: NSObject, NaxaLibreHostApi {
    
    private let binaryMessenger: FlutterBinaryMessenger
    private let libreView: MLNMapView
    private let args: Any?
    
    // NaxaLibreListeners
    public let naxaLibreListeners: NaxaLibreListeners
    
    // Init method for constructing instance of this class
    init(binaryMessenger: FlutterBinaryMessenger, libreView: MLNMapView, args: Any?) {
        self.binaryMessenger = binaryMessenger
        self.libreView = libreView
        self.args = args
        self.naxaLibreListeners = NaxaLibreListeners(binaryMessenger: binaryMessenger, libreView: libreView)
        super.init()
        
        NaxaLibreHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
        
        print(args ?? "No arguments provided")
        
        if let arguments = args as? [String: Any?] {
            if let styleURL = arguments["styleUrl"] as? String {
                self.libreView.styleURL = URL(string: styleURL)
            }
        }
    }
    
    func fromScreenLocation(point: [Double]) throws -> [Double] {
        let cgPoint = CGPoint(x: CGFloat(point[0]), y: CGFloat(point[1]))
        let coordinate = libreView.convert(cgPoint, toCoordinateFrom: nil)
        return [coordinate.longitude, coordinate.latitude]
    }
    
    func toScreenLocation(latLng: [Double]) throws -> [Double] {
        let coordinate = CLLocationCoordinate2D(latitude: latLng[0], longitude: latLng[1])
        let point = libreView.convert(coordinate, toPointTo: nil)
        return [Double(point.x), Double(point.y)]
    }
    
    func getLatLngForProjectedMeters(northing: Double, easting: Double) throws -> [Double] {
        
//        let point = MLNMapPoint(x: easting, y: northing, zoomLevel: 10)
//        let coordinate = point
//        return [coordinate.longitude, coordinate.latitude]
        return []
    }
    
    func getVisibleRegion(ignorePadding: Bool) throws -> [[Double]] {
        let bounds = libreView.visibleCoordinateBounds
        return [
            [bounds.sw.latitude, bounds.sw.longitude],
            [bounds.ne.latitude, bounds.ne.longitude]
        ]
    }
    
    func getProjectedMetersForLatLng(latLng: [Double]) throws -> [Double] {
//        let coordinate = CLLocationCoordinate2D(latitude: latLng[1], longitude: latLng[0])
//        let mapPoint = MLNMapPoint(coordinate: coordinate)
//        return [mapPoint.y, mapPoint.x]
        return [0.0, 0.0]
    }
    
    func getCameraPosition() throws -> [String : Any] {
        let camera = libreView.camera
        return [
            "target": [camera.centerCoordinate.latitude, camera.centerCoordinate.longitude],
            "zoom": libreView.zoomLevel,
            "bearing": camera.heading,
            "tilt": Double(camera.pitch)
        ]
    }
    
    func getZoom() throws -> Double {
        return Double(libreView.zoomLevel)
    }
    
    func getHeight() throws -> Double {
        return Double(libreView.bounds.height)
    }
    
    func getWidth() throws -> Double {
        return Double(libreView.bounds.width)
    }
    
    func getMinimumZoom() throws -> Double {
        return libreView.minimumZoomLevel
    }
    
    func getMaximumZoom() throws -> Double {
        return libreView.maximumZoomLevel
    }
    
    func getMinimumPitch() throws -> Double {
        return Double(libreView.minimumPitch)
    }
    
    func getMaximumPitch() throws -> Double {
        return Double(libreView.maximumPitch)
    }
    
    func getPixelRatio() throws -> Double {
        return Double(UIScreen.main.scale)
    }
    
    func isDestroyed() throws -> Bool {
        return libreView.superview == nil
    }
    
    func setMaximumFps(fps: Int64) throws {
        // MapLibre doesn't have a direct FPS setting method
        // This might require custom rendering logic
    }
    
    func setStyle(style: String) throws {
        libreView.styleURL = URL(string: style)
    }
    
    func setSwapBehaviorFlush(flush: Bool) throws {
        // MapLibre doesn't have a direct swap behavior method
    }
    
    func animateCamera(args: [String : Any?]) throws {
        guard let target = args["target"] as? [Double],
              let zoom = args["zoom"] as? Double else {
            throw NSError(domain: "Invalid camera arguments", code: 0, userInfo: nil)
        }
        
        let camera = MLNMapCamera(
            lookingAtCenter: CLLocationCoordinate2D(latitude: target[1], longitude: target[0]),
            altitude: 0,
            pitch: args["tilt"] as? Double ?? 0,
            heading: args["bearing"] as? Double ?? 0
        )
        
        libreView.zoomLevel = 10
        libreView.setCamera(camera, animated: true)
    }
    
    func easeCamera(args: [String : Any?]) throws {
        // Similar to animateCamera, but with a smoother transition
        guard let target = args["target"] as? [Double],
              let zoom = args["zoom"] as? Double else {
            throw NSError(domain: "Invalid camera arguments", code: 0, userInfo: nil)
        }
        
//        let camera = MLNMapCamera(
//            lookingAtCenter: CLLocationCoordinate2D(latitude: target[1], longitude: target[0]),
//            altitude: 0,
//            heading: args["bearing"] as? Double ?? 0,
//            pitch: args["tilt"] as? Double ?? 0
//        )
//        camera.zoom = zoom
//        
//        // Easing might require custom animation
//        libreView.setCamera(camera, animated: true)
    }
    
    func zoomBy(by: Int64) throws {
        libreView.setZoomLevel(try getZoom() + Double(by), animated: true)
    }
    
    func zoomIn() throws {
        libreView.setZoomLevel(try getZoom() + 1, animated: true)
    }
    
    func zoomOut() throws {
        libreView.setZoomLevel(try getZoom() - 1, animated: true)
    }
    
    func getCameraForLatLngBounds(bounds: [String : Any?]) throws -> [String : Any?] {
        guard let sw = bounds["southwest"] as? [Double],
              let ne = bounds["northeast"] as? [Double] else {
            throw NSError(domain: "Invalid bounds", code: 0, userInfo: nil)
        }
        
        let swCoord = CLLocationCoordinate2D(latitude: sw[1], longitude: sw[0])
        let neCoord = CLLocationCoordinate2D(latitude: ne[1], longitude: ne[0])
        
        let bounds = MLNCoordinateBounds(sw: swCoord, ne: neCoord)
        let camera = libreView.cameraThatFitsCoordinateBounds(bounds)
        
        return [
            "target": [camera.centerCoordinate.latitude, camera.centerCoordinate.longitude],
            "zoom": libreView.zoomLevel,
            "bearing": camera.heading,
            "tilt": camera.pitch
        ]
    }
    
    func queryRenderedFeatures(args: [String : Any?]) throws -> [[AnyHashable? : Any?]] {
        guard let point = args["point"] as? [Double] else {
            throw NSError(domain: "Invalid point", code: 0, userInfo: nil)
        }
        
        let cgPoint = CGPoint(x: CGFloat(point[0]), y: CGFloat(point[1]))
        let features = libreView.visibleFeatures(at: cgPoint)
        
        return features.map { feature in
            return feature.attributes as? [AnyHashable? : Any?] ?? [:]
        }
    }
    
    func setLogoMargins(left: Double, top: Double, right: Double, bottom: Double) throws {
        libreView.logoView.frame.origin.x = CGFloat(left)
        libreView.logoView.frame.origin.y = CGFloat(top)
    }
    
    func isLogoEnabled() throws -> Bool {
        return !libreView.logoView.isHidden
    }
    
    func setCompassMargins(left: Double, top: Double, right: Double, bottom: Double) throws {
        libreView.compassView.frame.origin.x = CGFloat(left)
        libreView.compassView.frame.origin.y = CGFloat(top)
    }
    
    func setCompassImage(bytes: FlutterStandardTypedData) throws {
//        guard let image = UIImage(data: bytes.data()) else {
//            throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
//        }
//        libreView.compassView.image = image
    }
    
    func setCompassFadeFacingNorth(compassFadeFacingNorth: Bool) throws {
        // MapLibre doesn't have a direct method for this
    }
    
    func isCompassEnabled() throws -> Bool {
        return !libreView.compassView.isHidden
    }
    
    func isCompassFadeWhenFacingNorth() throws -> Bool {
        return false // MapLibre doesn't have a direct method for this
    }
    
    func setAttributionMargins(left: Double, top: Double, right: Double, bottom: Double) throws {
        libreView.attributionButton.frame.origin.x = CGFloat(left)
        libreView.attributionButton.frame.origin.y = CGFloat(top)
    }
    
    func isAttributionEnabled() throws -> Bool {
        return !libreView.attributionButton.isHidden
    }
    
    func setAttributionTintColor(color: Int64) throws {
        libreView.attributionButton.tintColor = UIColor(rgb: color)
    }
    
    func getUri() throws -> String {
        return libreView.styleURL?.absoluteString ?? ""
    }
    
    func getJson() throws -> String {
        // This would require parsing the style JSON
        return ""
    }
    
    func getLight() throws -> [String : Any] {
        // MapLibre doesn't have a direct light properties method
        return [:]
    }
    
    func isFullyLoaded() throws -> Bool {
        return false
    }
    
    func getLayer(id: String) throws -> [String : Any?] {
        guard let layer = libreView.style?.layer(withIdentifier: id) else {
            throw NSError(domain: "Layer not found", code: 0, userInfo: nil)
        }
        return ["id": layer.identifier, "type": "layer.type"]
    }
    
    func getLayers(id: String) throws -> [[String : Any?]] {
        return libreView.style?.layers.compactMap { layer in
            ["id": layer.identifier, "type": "layer.type"]
        } ?? []
    }
    
    func getSource(id: String) throws -> [String : Any?] {
        guard let source = libreView.style?.source(withIdentifier: id) else {
            throw NSError(domain: "Source not found", code: 0, userInfo: nil)
        }
        return ["id": source.identifier]
    }
    
    func getSources() throws -> [[String : Any?]] {
        return libreView.style?.sources.compactMap { source in
            ["id": source.identifier]
        } ?? []
    }
    
    func addImage(name: String, bytes: FlutterStandardTypedData) throws {
//        guard let image = UIImage(data: bytes.data()) else {
//            throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
//        }
//        libreView.style?.setImage(image, forName: name)
    }
    
    func addImages(images: [String : FlutterStandardTypedData]) throws {
//        for (name, bytes) in images {
//            guard let image = UIImage(data: bytes.data()) else {
//                throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
//            }
//            libreView.style?.setImage(image, forName: name)
//        }
    }
    
    func addLayer(layer: [String : Any?]) throws {
        // This would require creating a MapLibre layer from the dictionary
        // Implementation depends on specific layer type
    }
    
    func addSource(source: [String : Any?]) throws {
        // This would require creating a MapLibre source from the dictionary
        // Implementation depends on specific source type
    }
    
    func removeLayer(id: String) throws -> Bool {
        guard let layer = libreView.style?.layer(withIdentifier: id) else {
            return false
        }
        libreView.style?.removeLayer(layer)
        return true
    }
    
    func removeLayerAt(index: Int64) throws -> Bool {
        guard let layers = libreView.style?.layers, index < layers.count else {
            return false
        }
        libreView.style?.removeLayer(layers[Int(index)])
        return true
    }
    
    func removeSource(id: String) throws -> Bool {
        guard let source = libreView.style?.source(withIdentifier: id) else {
            return false
        }
        libreView.style?.removeSource(source)
        return true
    }
    
    func removeImage(name: String) throws {
        libreView.style?.removeImage(forName: name)
    }
    
    func getImage(id: String) throws -> FlutterStandardTypedData {
        guard let image = libreView.style?.image(forName: id),
              let data = image.pngData() else {
            throw NSError(domain: "Image not found", code: 0, userInfo: nil)
        }
        return FlutterStandardTypedData(bytes: data)
    }
    
    func lastKnownLocation() throws -> [Double] {
        return []
    }
    
    func getLayer(id: String) throws -> [AnyHashable? : Any?] {
        guard let layer = libreView.style?.layer(withIdentifier: id) else {
            throw NSError(domain: "Layer not found", code: 0, userInfo: nil)
        }
        
        return [
            "id": layer.identifier,
            "min_zoom": layer.minimumZoomLevel,
            "max_zoom": layer.maximumZoomLevel,
            "visibility": layer.isVisible
        ]
    }
    
    func getLayers() throws -> [[AnyHashable? : Any?]] {
        guard let layers = libreView.style?.layers else {
            return []
        }
        
        return layers.map { layer in
            [
                "id": layer.identifier,
                "min_zoom": layer.minimumZoomLevel,
                "max_zoom": layer.maximumZoomLevel,
                "visibility": layer.isVisible
            ]
        }
    }
    
    func getSource(id: String) throws -> [AnyHashable? : Any?] {
        guard let source = libreView.style?.source(withIdentifier: id) else {
            throw NSError(domain: "Source not found", code: 0, userInfo: nil)
        }
        
        return [
            "id": source.identifier,
            "attribution": source.description,
        ]
    }
    
    func getSources() throws -> [[AnyHashable? : Any?]] {
        guard let sources = libreView.style?.layers else {
            return []
        }
        
        return sources.map { source in
            [
                "id": source.identifier,
                "attribution": source.description,
            ]
        }
    }
    
    func snapshot(completion: @escaping (Result<FlutterStandardTypedData, any Error>) -> Void) {
        let options = MLNMapSnapshotOptions(
            styleURL: libreView.styleURL,
            camera: libreView.camera,
            size: libreView.bounds.size
        )
        options.zoomLevel = libreView.zoomLevel
        
        
        // Create the map snapshot.
        let snapshotter: MLNMapSnapshotter? = MLNMapSnapshotter(options: options)
        snapshotter?.start { snapshot, error in
            if error != nil {
                completion(.failure(NSError(domain: "Unable to create smapshot", code: 0, userInfo: nil)))
            } else if let snapshot {
                guard let data = snapshot.image.pngData() else {
                    completion(.failure(NSError(domain: "Unable to create smapshot", code: 0, userInfo: nil)))
                    return
                }
                let typedData = FlutterStandardTypedData(bytes: data)
                completion(.success(typedData))
            }
        }
    }
    
    func triggerRepaint() throws {
     
    }
}

// Utility extension for converting integer color to UIColor
extension UIColor {
    convenience init(rgb: Int64) {
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
