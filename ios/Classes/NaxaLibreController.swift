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
    
    // MARK: NaxaLibreListeners
    public let naxaLibreListeners: NaxaLibreListeners
    
    // MARK: NaxaLibreAnnotationsManager
    private let libreAnnotationsManager: NaxaLibreAnnotationsManager
    
    // MARK: NaxaLibreOfflineManager
    private lazy var libreOfflineManager: NaxaLibreOfflineManager = NaxaLibreOfflineManager(
        binaryMessenger: binaryMessenger,
        libreView: libreView
    )
    
    // MARK: Init method for constructing instance of this class
    init(binaryMessenger: FlutterBinaryMessenger, libreView: MLNMapView, args: Any?) {
        self.binaryMessenger = binaryMessenger
        self.libreView = libreView
        self.args = args
        
        self.libreAnnotationsManager = NaxaLibreAnnotationsManager(
            binaryMessenger: binaryMessenger,
            libreView: libreView
        )
        
        self.naxaLibreListeners = NaxaLibreListeners(
            binaryMessenger: binaryMessenger,
            libreView: libreView,
            libreAnnotationsManager: libreAnnotationsManager,
            args: args
        )
        super.init()
        
        NaxaLibreHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)
        if args != nil {
            handleCreationParams()
        }
    }
    
    func fromScreenLocation(point: [Double]) throws -> [Double] {
        let cgPoint = CGPoint(x: CGFloat(point[0]), y: CGFloat(point[1]))
        let coordinate = libreView.mapProjection().convert(cgPoint)
        return [coordinate.longitude, coordinate.latitude]
    }
    
    func fromScreenLocations(points: [[Double]], completion: @escaping (Result<[[Any?]], any Error>) -> Void) {
        // Create a dispatch group to track all conversions
        let dispatchGroup = DispatchGroup()
        var convertedPoints: [[Double]] = Array(repeating: [], count: points.count)
        var conversionError: Error? = nil
        
        // Process each point
        for (index, point) in points.enumerated() {
            // Validate point format
            guard point.count >= 2 else {
                completion(.failure(NSError(domain: "InvalidPointFormatError", code: 0, userInfo: nil)))
                return
            }
            
            // Enter the dispatch group before starting work
            dispatchGroup.enter()
            
            // If we already encountered an error, don't do the conversion
            if conversionError == nil {
                do {
                    let convertedPoint = try self.fromScreenLocation(point: point)
                    convertedPoints[index] = convertedPoint
                    dispatchGroup.leave()
                } catch {
                    conversionError = error
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        
        // When all conversions are complete, call the completion handler
        dispatchGroup.notify(queue: .main) {
            if let error = conversionError {
                completion(.failure(error))
            } else {
                completion(.success(convertedPoints))
            }
        }
    }
    
    func toScreenLocation(latLng: [Double]) throws -> [Double] {
        let coordinate = CLLocationCoordinate2D(latitude: latLng[0], longitude: latLng[1])
        let point = libreView.mapProjection().convert(coordinate)
        return [Double(point.x), Double(point.y)]
    }
    
    func toScreenLocations(listOfLatLng: [[Double]], completion: @escaping (Result<[[Any?]], any Error>) -> Void) {
        // Create a dispatch group to track all conversions
        let dispatchGroup = DispatchGroup()
        var convertedScreenPoints: [[Double]] = Array(repeating: [], count: listOfLatLng.count)
        var conversionError: Error? = nil
        
        // Process each coordinate
        for (index, latLng) in listOfLatLng.enumerated() {
            // Validate coordinate format
            guard latLng.count >= 2 else {
                completion(.failure(NSError(domain: "Invalid coordinate format", code: 0, userInfo: nil)))
                return
            }
            
            // Enter the dispatch group before starting work
            dispatchGroup.enter()
            
            // If we haven't encountered an error yet, proceed with conversion
            if conversionError == nil {
                do {
                    let screenPoint = try self.toScreenLocation(latLng: latLng)
                    convertedScreenPoints[index] = screenPoint
                    dispatchGroup.leave()
                } catch {
                    conversionError = error
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        
        // When all conversions are complete, call the completion handler
        dispatchGroup.notify(queue: .main) {
            if let error = conversionError {
                completion(.failure(error))
            } else {
                completion(.success(convertedScreenPoints))
            }
        }
    }

    
    func getLatLngForProjectedMeters(northing: Double, easting: Double) throws -> [Double] {
        return [0.0, 0.0, 0.0]
    }
    
    func getVisibleRegion(ignorePadding: Bool) throws -> [[Double]] {
        let bounds = libreView.visibleCoordinateBounds
        return [
            [bounds.sw.latitude, bounds.sw.longitude],
            [bounds.ne.latitude, bounds.ne.longitude]
        ]
    }
    
    func getProjectedMetersForLatLng(latLng: [Double]) throws -> [Double] {
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
        libreView.preferredFramesPerSecond = MLNMapViewPreferredFramesPerSecond(Int(fps))
    }
    
    func setStyle(style: String) throws {
        if style.isWebURL {
            libreView.styleURL = URL(string: style)
        } else if style.isFilePath {
            libreView.styleURL = URL(fileURLWithPath: style)
        } else if style.isJSONString {
            libreView.styleURL = try style.styleUrl()
        } else {
            throw NSError(domain: "Unsupported style format", code: 0, userInfo: nil)
        }
    }
    
    func setSwapBehaviorFlush(flush: Bool) throws {
        // MapLibre doesn't have a direct swap behavior method
        throw NSError(domain: "Currently not supported in IOS", code: 0, userInfo: nil)
    }
    
    func setAllGesturesEnabled(enabled: Bool) throws {
        libreView.isRotateEnabled = enabled
        libreView.isZoomEnabled = enabled
        libreView.isScrollEnabled = enabled
        libreView.isPitchEnabled = enabled
        libreView.isUserInteractionEnabled = enabled
    }
    
    func animateCamera(args: [String : Any?]) throws {
        try handleEaseAndAnimateCamera(args: args)
    }
    
    func easeCamera(args: [String : Any?]) throws {
        try handleEaseAndAnimateCamera(args: args)
    }
    
    func zoomBy(by: Double) throws {
        libreView.setZoomLevel(try getZoom() + by, animated: true)
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
        
        let pointArgs = args["point"] as? [Any]
        let rectArgs = args["rect"] as? [Any]
        
        if pointArgs == nil && rectArgs == nil {
            throw NSError(
                domain: "NaxaLibreController",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Point or rect is required"]
            )
        }
        
        let layerIds = args["layerIds"] as? [String]
        let filter = (args["filter"] as? String).flatMap { NaxaLibrePredicateUtils.predicateFromValue($0) }
        
        
        if let point = pointArgs as? [Double] {
            if point.count != 2 {
                throw NSError(
                    domain: "NaxaLibreController",
                    code: 400,
                    userInfo: [NSLocalizedDescriptionKey: "Point must have x and y coordinates"]
                )
            }
            
            let cgPoint = CGPoint(x: CGFloat(point[0]), y: CGFloat(point[1]))
            let features = libreView.visibleFeatures(
                at: cgPoint,
                styleLayerIdentifiers: layerIds != nil && !layerIds!.isEmpty ? Set(layerIds!) : nil,
                predicate: filter
            )
            
            return features.map { $0.geoJSONDictionary() }
        }
        
        if let rect = rectArgs as? [Double] {
            if rect.count != 4 {
                throw NSError(
                    domain: "NaxaLibreController",
                    code: 400,
                    userInfo: [NSLocalizedDescriptionKey: "Rect must have 4 corner values"]
                )
            }
            
            let cgRect = CGRect(
                x: Int(rect[0]),
                y: Int(rect[1]),
                width: Int(rect[2] - rect[0]),
                height: Int(rect[3] - rect[1])
            )
            
            let features = libreView.visibleFeatures(
                in: cgRect,
                styleLayerIdentifiers: layerIds != nil && !layerIds!.isEmpty ? Set(layerIds!) : nil,
                predicate: filter
            )
            
            return features.map { $0.geoJSONDictionary() }
            
        }
        
        throw NSError(
            domain: "NaxaLibreController",
            code: 400,
            userInfo: [NSLocalizedDescriptionKey: "Unable to parse arguments"]
        )
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
        guard let image = UIImage(data: bytes.data) else {
            throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
        }
        libreView.compassView.image = image
    }
    
    func setCompassFadeFacingNorth(compassFadeFacingNorth: Bool) throws {
        throw NSError(domain: "Not supported", code: 0, userInfo: nil)
    }
    
    func isCompassEnabled() throws -> Bool {
        return !libreView.compassView.isHidden
    }
    
    func isCompassFadeWhenFacingNorth() throws -> Bool {
        throw NSError(domain: "Not supported", code: 0, userInfo: nil)
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
    
    func getJson(completion: @escaping (Result<String, any Error>) -> Void) {
        guard let url = libreView.styleURL else {
            completion(.failure(NSError(domain: "Map style is not loaded", code: -1, userInfo: nil)))
            return
        }
        
        switch url.scheme {
            case "http", "https":
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                        completion(.success(jsonString))
                    } else {
                        completion(.failure(error ?? NSError(domain: "Unable to load style JSON", code: -1, userInfo: nil)))
                    }
                }.resume()
                
            case "file":
                do {
                    let jsonString = try String(contentsOf: url, encoding: .utf8)
                    completion(.success(jsonString))
                } catch {
                    completion(.failure(error))
                }
                
            default:
                completion(.failure(NSError(domain: "Unsupported URL scheme", code: -1, userInfo: nil)))
        }
    }
    
    func getLight() throws -> [String : Any] {
        guard let light = libreView.style?.light else {
            throw NSError(domain: "Light not found", code: 0, userInfo: nil)
        }
        
        return [
            "anchor" : String(describing: light.anchor.constantValue),
            "color": (light.color.constantValue as? UIColor)?.hexString ?? "#fff",
            "intensity": light.intensity.constantValue ?? 0
        ]
    }
    
    func isFullyLoaded() throws -> Bool {
        return libreView.superview != nil && libreView.style != nil
    }
    
    func getLayer(id: String) throws -> [AnyHashable? : Any?] {
        guard let layer = libreView.style?.layer(withIdentifier: id) else {
            throw NSError(domain: "Layer not found", code: 0, userInfo: nil)
        }
        return LayerArgsParser.extractArgsFromLayer(layer: layer)
    }
    
    func getLayers() throws -> [[AnyHashable? : Any?]] {
        return libreView.style?.layers.compactMap { layer in
            LayerArgsParser.extractArgsFromLayer(layer: layer)
        } ?? []
    }
    
    func getSource(id: String) throws -> [AnyHashable? : Any?] {
        guard let source = libreView.style?.source(withIdentifier: id) else {
            throw NSError(domain: "Source not found", code: 0, userInfo: nil)
        }
        return ["id": source.identifier]
    }
    
    func getSources() throws -> [[AnyHashable? : Any?]] {
        return libreView.style?.sources.compactMap { source in
            ["id": source.identifier]
        } ?? []
    }
    
    func addImage(name: String, bytes: FlutterStandardTypedData) throws {
        guard let image = UIImage(data: bytes.data) else {
            throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
        }
        libreView.style?.setImage(image, forName: name)
    }
    
    func addImages(images: [String : FlutterStandardTypedData]) throws {
        for (name, bytes) in images {
            guard let image = UIImage(data: bytes.data) else {
                continue
            }
            libreView.style?.setImage(image, forName: name)
        }
    }
    
    func addLayer(layer: [String : Any?]) throws {
        guard let type = layer["type"] as? String else {
            throw NSError(
                domain: "NaxaLibreController",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Missing type argument"]
            )
        }
        
        guard let layerId = layer["layerId"] as? String else {
            throw NSError(
                domain: "NaxaLibreController",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Missing layerId argument"]
            )
        }
        
        if libreView.style?.layer(withIdentifier: layerId) != nil {
            throw NSError(
                domain: "NaxaLibreController",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Unable to apply layer as it is already applied"]
            )
        }
        
        guard let sourceId = layer["sourceId"] as? String else {
            throw NSError(
                domain: "NaxaLibreController",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Missing sourceId argument"]
            )
        }
        
        let index = layer["index"] as? Int
        let below = layer["below"] as? String
        let above = layer["above"] as? String
        
        // Source is not required for background layer.
        if type == "background" {
            guard let layer = LayerArgsParser.parseArgs(layer, source: nil) else {
                throw NSError(
                    domain: "NaxaLibreController",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey : "Unable to apply layer as it is not valid"]
                )
            }
            
            if let i = index {
                libreView.style?.insertLayer(layer, at: UInt(i))
                return
            }
            
            if let belowId = below {
                if let belowLayer = libreView.style?.layer(withIdentifier: belowId) {
                    libreView.style?.insertLayer(layer, below: belowLayer)
                    return
                }
            }
            
            if let aboveId = above {
                if let aboveLayer = libreView.style?.layer(withIdentifier: aboveId) {
                    libreView.style?.insertLayer(layer, above: aboveLayer)
                    return
                }
            }
            
            libreView.style?.addLayer(layer)
            return
        }
        
        // Else get source
        guard let source = libreView.style?.source(withIdentifier: sourceId) else {
            throw NSError(
                domain: "NaxaLibreController",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Source Not found to add layer"]
            )
        }
        
        guard let layer = LayerArgsParser.parseArgs(layer, source: source) else {
            throw NSError(
                domain: "NaxaLibreController",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Unable to apply layer as it is not valid"]
            )
        }
        
        if let i = index {
            libreView.style?.insertLayer(layer, at: UInt(i))
            return
        }
        
        if let belowId = below {
            if let belowLayer = libreView.style?.layer(withIdentifier: belowId) {
                libreView.style?.insertLayer(layer, below: belowLayer)
                return
            }
        }
        
        if let aboveId = above {
            if let aboveLayer = libreView.style?.layer(withIdentifier: aboveId) {
                libreView.style?.insertLayer(layer, above: aboveLayer)
                return
            }
        }
        
        libreView.style?.addLayer(layer)
    }
    
    func addSource(source: [String : Any?]) throws {
        let source = try SourceArgsParser.parseArgs(source)
        
        if libreView.style?.source(withIdentifier: source.identifier) != nil {
            throw NSError(
                domain: "NaxaLibreController",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey : "Unable to add source as it is already added"]
            )
        }
        
        libreView.style?.addSource(source)
    }
    
    func setGeoJsonData(sourceId: String, jsonString: String) throws {
        guard let source = libreView.style?.source(withIdentifier: sourceId) as? MLNShapeSource else {
            throw NSError(domain: "GeoJSON source not found", code: 0, userInfo: nil)
        }
        
        if let geoJSONData = jsonString.data(using: .utf8) {
            do {
                // Parse the GeoJSON data into a shape
                let shape = try MLNShape(data: geoJSONData, encoding: String.Encoding.utf8.rawValue)
                
                // Update GeoJSON shape to existing MLNShapeSource
                source.shape = shape
                
            } catch {
                throw NSError(domain: "Invalid GeoJSON", code: 0, userInfo: nil)
            }
        } else {
            throw NSError(domain: "Invalid GeoJSON", code: 0, userInfo: nil)
        }
    }
    
    func setGeoJsonUri(sourceId: String, uri: String) throws {
        guard let source = libreView.style?.source(withIdentifier: sourceId) as? MLNShapeSource else {
            throw NSError(domain: "GeoJSON source not found", code: 0, userInfo: nil)
        }
        
        if let uri = URL(string: uri) {
            source.url = uri
        }
    }
    
    func addAnnotation(annotation: [String : Any?]) throws -> [String : Any?] {
        return try libreAnnotationsManager.addAnnotation(args: annotation)
    }
    
    func updateAnnotation(id: Int64, annotation: [String : Any?]) throws -> [String : Any?] {
        return try libreAnnotationsManager.updateAnnotation(id: id, args: annotation)
    }
    
    func getAnnotation(id: Int64) throws -> [String : Any?]? {
        return libreAnnotationsManager.getAnnotation(id: id)
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
    
    func removeAnnotation(args: [String : Any?]) throws {
        try libreAnnotationsManager.deleteAnnotation(args: args)
    }
    
    func removeAllAnnotations(args: [String : Any?]) throws {
        try libreAnnotationsManager.deleteAllAnnotations(args: args)
    }
    
    func getImage(id: String) throws -> FlutterStandardTypedData {
        guard let image = libreView.style?.image(forName: id),
              let data = image.pngData() else {
            throw NSError(domain: "Image not found", code: 0, userInfo: nil)
        }
        return FlutterStandardTypedData(bytes: data)
    }
    
    func lastKnownLocation() throws -> [Double] {
        guard let location = libreView.userLocation else {
            throw NSError(domain: "Location not found", code: 0, userInfo: nil)
        }
        return [location.coordinate.latitude, location.coordinate.longitude]
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
        libreView.triggerRepaint()
    }
    
    func resetNorth() throws {
        libreView.resetNorth()
    }
    
    func downloadRegion(args: [String : Any?], completion: @escaping (Result<[AnyHashable? : Any?], any Error>) -> Void) {
        libreOfflineManager.download(args: args, completion: completion)
    }
    
    func cancelDownloadRegion(id: Int64, completion: @escaping (Result<Bool, any Error>) -> Void) {
        libreOfflineManager.cancelDownload(id: id, completion: completion)
    }
    
    func getRegion(id: Int64, completion: @escaping (Result<[AnyHashable? : Any?], any Error>) -> Void) {
        libreOfflineManager.getRegion(id: id, completion: completion)
    }
    
    func deleteRegion(id: Int64, completion: @escaping (Result<Bool, any Error>) -> Void) {
        libreOfflineManager.deleteRegion(id: id, completion: completion)
    }
    
    func deleteAllRegions(completion: @escaping (Result<[Int64 : Bool], any Error>) -> Void) {
        libreOfflineManager.deleteAllRegions(completion: completion)
    }
    
    func listRegions(completion: @escaping (Result<[[AnyHashable? : Any?]], any Error>) -> Void) {
        libreOfflineManager.listRegions(completion: completion)
    }
    
    private func handleEaseAndAnimateCamera(args: [String: Any?]) throws {
        let duration = args["duration"] as? Int64
        
        switch args["type"] as? String {
            case "newCameraPosition":
                if let cameraPositionArgs = args["camera_position"] as? [String: Any] {
                    let libreMapCamera = NaxaLibreMapCameraArgsParser.parseArgs(cameraPositionArgs)
                    
                    let altitude = NaxaLibreAltitudeUtils.calculateAltitude(
                        forZoom: libreMapCamera.zoom == 0.0 ? libreView.zoomLevel : libreMapCamera.zoom,
                        screenHeight: Double(libreView.bounds.height)
                    )
                    
                    let camera = MLNMapCamera(
                        lookingAtCenter: libreMapCamera.target,
                        altitude: altitude,
                        pitch: libreMapCamera.tilt,
                        heading: libreMapCamera.bearing
                    )
                    
                    if let duration = duration {
                        libreView.fly(
                            to: camera,
                            edgePadding: libreMapCamera.padding,
                            withDuration: TimeInterval(duration / 1000)
                        )
                    } else {
                        libreView.fly(
                            to: camera,
                            edgePadding: libreMapCamera.padding,
                            withDuration: TimeInterval(0.25)
                        )
                    }
                }
                
            case "newLatLng":
                if let latLng = args["latLng"] as? [Any],
                   let lat = latLng[0] as? Double,
                   let lng = latLng[1] as? Double {
                    
                    let zoom = args["zoom"] as? Double
                    
                    let altitude = {
                        if let zoom = args["zoom"] as? Double {
                            return NaxaLibreAltitudeUtils.calculateAltitude(
                                forZoom: zoom,
                                screenHeight: Double(libreView.bounds.height)
                            )
                        } else {
                            return libreView.camera.altitude
                        }
                    }()
                    
                    let camera = MLNMapCamera(
                        lookingAtCenter: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                        altitude: altitude,
                        pitch: libreView.camera.pitch,
                        heading: libreView.camera.heading
                    )
                    
                    if let duration = duration {
                        libreView.fly(to: camera, withDuration: TimeInterval(duration / 1000))
                    } else {
                        libreView.fly(to: camera, withDuration: TimeInterval(0.25))
                    }
                }
                
            case "newLatLngBounds":
                if let bounds = args["bounds"] as? [String: Any],
                   let northEast = bounds["northeast"] as? [Any],
                   let southWest = bounds["southwest"] as? [Any] {
                    
                    let padding = bounds["padding"] as? Double
                    let bearing = bounds["bearing"] as? Double
                    let tilt = bounds["tilt"] as? Double
                    
                    guard let swLat = southWest[0] as? Double,
                          let swLng = southWest[1] as? Double,
                          let neLat = northEast[0] as? Double,
                          let neLng = northEast[1] as? Double else {
                        throw NSError(domain: "Invalid bounds", code: 0, userInfo: nil)
                    }
                    
                    let latLngBounds = MLNCoordinateBounds(
                        sw: CLLocationCoordinate2D(latitude: swLat, longitude: swLng),
                        ne: CLLocationCoordinate2D(latitude: neLat, longitude: neLng)
                    )
                    
                    let camera = libreView.cameraThatFitsCoordinateBounds(
                        latLngBounds,
                        edgePadding: padding != nil ? UIEdgeInsets(top: CGFloat(padding!), left: CGFloat(padding!), bottom: CGFloat(padding!), right: CGFloat(padding!)) : .zero
                    )
                    
                    if let bearing = bearing {
                        camera.heading = bearing
                    }
                    
                    if let tilt = tilt {
                        camera.pitch = tilt
                    }
                    
                    if let duration = duration {
                        libreView.fly(to: camera, withDuration: TimeInterval(duration/1000))
                    } else {
                        libreView.fly(to: camera, withDuration: TimeInterval(0.25))
                    }
                }
                
            case "zoomTo":
                if let zoom = args["zoom"] as? Double {
                    let altitude = NaxaLibreAltitudeUtils.calculateAltitude(
                        forZoom: zoom,
                        screenHeight: Double(libreView.bounds.height)
                    )
                    
                    let camera = MLNMapCamera(
                        lookingAtCenter: libreView.centerCoordinate,
                        altitude: altitude,
                        pitch: libreView.camera.pitch,
                        heading: libreView.camera.heading
                    )
                    
                    if let duration = duration {
                        libreView.fly(to: camera, withDuration: TimeInterval(duration / 1000))
                    } else {
                        libreView.fly(to: camera, withDuration: TimeInterval(0.25))
                    }
                }
                
            case "zoomBy":
                if let by = args["zoom"] as? Double {
                    let altitude = NaxaLibreAltitudeUtils.calculateAltitude(
                        forZoom: libreView.zoomLevel + by,
                        screenHeight: Double(libreView.bounds.height)
                    )
                    
                    let camera = MLNMapCamera(
                        lookingAtCenter: libreView.centerCoordinate,
                        altitude: altitude,
                        pitch: libreView.camera.pitch,
                        heading: libreView.camera.heading
                    )
                    
                    if let duration = duration {
                        libreView.fly(to: camera, withDuration: TimeInterval(duration / 1000))
                    } else {
                        libreView.fly(to: camera, withDuration: TimeInterval(0.25))
                    }
                }
                
            default:
                throw NSError(domain: "Invalid camera update type: \(String(describing: args["type"]))", code: -1, userInfo: nil)
        }
    }
    
    /// Handles the initial parameters passed to the map view.
    ///
    /// This function parses the initial parameters, specifically focusing on UI settings,
    /// and applies them to the provided MapLibreMap instance.
    ///
    /// - SeeAlso: `UiSettingsArgsParser.parseArgs` for details on how UI settings are parsed.
    /// - SeeAlso: `handleUiSettings` for how the UI settings are applied to the map.
    private func handleCreationParams() {
        if let creationArgs = args as? [String: Any?] {
            if let styleURL = creationArgs["styleUrl"] as? String {
                do {
                    try setStyle(style: styleURL)
                } catch {
                    // Unable to set style
                }
            }
            
            if let mapOptionsArgs = creationArgs["mapOptions"] as? [String: Any?] {
                handleMapOptions(mapOptionsArgs)
            }
            
            if let uiSettingsArgs = creationArgs["uiSettings"] as? [String: Any?] {
                handleUiSettings(uiSettingsArgs)
            }
            
            if let locationSettingArgs = creationArgs["locationSettings"] as? [String: Any?] {
                handleLocationSettings(locationSettingArgs)
            }
        }
    }

    
    /// Handles the configuration of UI settings for the map view based on the provided arguments.
    /// - Parameter args: A dictionary containing UI setting options.
    ///
    /// This function parses the provided arguments into a `NaxaLibreUiSettings` instance using `NaxaLibreUiSettingsArgsParser`.
    /// It then applies these settings to the `libreView` instance, adjusting visibility, positioning, margins, and gesture settings accordingly.
    ///
    private func handleUiSettings(_ args: [String: Any?]) {
        let uiSettings = NaxaLibreUiSettingsArgsParser.parseArgs(args)
        libreView.applyUiSettings(uiSettings)
    }
    
    /// Handles the processing of map options by parsing the provided arguments and applying them to the map view.
    /// - Parameter args: A dictionary containing map configuration options.
    ///
    /// This function parses the provided arguments into a `NaxaLibreMapOptions` instance using `NaxaLibreMapOptionsArgsParser`
    /// and then applies these options to the `libreView` instance.
    private func handleMapOptions(_ args: [String: Any?]) {
        let options = NaxaLibreMapOptionsArgsParser.parseArgs(args)
        libreView.applyMapOptions(options)
    }
    
    /// Handles the processing of location settings options by parsing the provided arguments and applying them to the map view.
    /// - Parameter args: A dictionary containing map configuration options.
    ///
    /// This function parses the provided arguments into a `NaxaLibreLocationSettings` instance using `NaxaLibreLocationSettingsArgsParser`
    /// and then applies these options to the `libreView` instance.
    private func handleLocationSettings(_ args: [String: Any?]) {
        let locationSettings = NaxaLibreLocationSettingsArgsParser.parseArgs(args)
        
        libreView.showsUserLocation = locationSettings.locationEnabled
        
        if locationSettings.locationEnabled {
            
            let manager = NaxaLibreLocationManager()
            manager.applyLocationSettings(locationSettings)
            
            libreView.locationManager = manager
            
            libreView.shouldRequestAuthorizationToUseLocationServices = locationSettings.shouldRequestAuthorizationOrPermission
        }
    }
    
    deinit {
        naxaLibreListeners.unregister()
    }
}
