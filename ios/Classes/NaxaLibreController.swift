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
    
    // MARK: Init method for constructing instance of this class
    init(binaryMessenger: FlutterBinaryMessenger, libreView: MLNMapView, args: Any?) {
        self.binaryMessenger = binaryMessenger
        self.libreView = libreView
        self.args = args
        self.naxaLibreListeners = NaxaLibreListeners(
            binaryMessenger: binaryMessenger,
            libreView: libreView,
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
    
    func toScreenLocation(latLng: [Double]) throws -> [Double] {
        let coordinate = CLLocationCoordinate2D(latitude: latLng[0], longitude: latLng[1])
        let point = libreView.mapProjection().convert(coordinate)
        return [Double(point.x), Double(point.y)]
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
        libreView.styleURL = URL(string: style)
    }
    
    func setSwapBehaviorFlush(flush: Bool) throws {
        // MapLibre doesn't have a direct swap behavior method
        throw NSError(domain: "Currently not supported in IOS", code: 0, userInfo: nil)
    }
    
    func animateCamera(args: [String : Any?]) throws {
        try handleEaseAndAnimateCamera(args: args)
    }
    
    func easeCamera(args: [String : Any?]) throws {
        try handleEaseAndAnimateCamera(args: args)
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
            return feature.geoJSONDictionary()
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
    
    func getJson() throws -> String {
        guard let style = libreView.style else {
            throw NSError(domain: "Map style is not loaded", code: -1, userInfo: nil)
        }
        
        // Create a dictionary to represent the style
        var styleDictionary: [String: Any] = [:]
        
        // Add style properties to the dictionary
        styleDictionary["name"] = style.name
        styleDictionary["sources"] = style.sources.map { $0.identifier }
        styleDictionary["layers"] = style.layers.map { $0.identifier }
        
        // Serialize the dictionary to JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: styleDictionary, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                throw NSError(domain: "Failed to convert JSON data to string", code: -2, userInfo: nil)
            }
        } catch {
            throw NSError(domain: "Failed to serialize style to JSON: \(error.localizedDescription)", code: -3, userInfo: nil)
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
        guard let location = libreView.userLocation else {
            throw NSError(domain: "Location not found", code: 0, userInfo: nil)
        }
        return [location.coordinate.latitude, location.coordinate.longitude]
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
        libreView.triggerRepaint()
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
                    let camera = MLNMapCamera(
                        lookingAtCenter: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                        altitude: libreView.camera.altitude,
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
                self.libreView.styleURL = URL(string: styleURL)
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
