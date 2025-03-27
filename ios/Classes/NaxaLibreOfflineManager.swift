//
//  NaxaLibreOfflineManager.swift
//  naxalibre
//
//  Created by Amit on 15/03/2025.
//

import Foundation
import Flutter
import MapLibre

/**
 * Manages offline map capabilities within the NaxaLibre application.
 *
 * This class provides functionality for downloading, managing, and monitoring offline map regions.
 * It interacts with MapLibre's OfflineManager to handle offline data storage and retrieval.
 */
class NaxaLibreOfflineManager {
    private let binaryMessenger: FlutterBinaryMessenger
    private let libreView: MLNMapView
    
    /**
     * An instance of the LibreOffice OfflineManager.
     *
     * This property provides access to the LibreOffice OfflineManager, which is responsible
     * for managing offline capabilities of the LibreOffice application. This includes features
     * like caching, offline document access, and synchronization.
     */
    private lazy var libreOfflineManager: MLNOfflineStorage = {
        return MLNOfflineStorage.shared
    }()
    
    /**
     * A mutable map storing the currently downloading offline regions.
     *
     * Key: The region's ID (NSNumber).
     * Value: The OfflineRegion object representing the downloading region.
     */
    private var downloadingRegions = [Int64: MLNOfflinePack]()
    
    /**
     * Initializes a new instance of NaxaLibreOfflineManager.
     *
     * @param binaryMessenger The FlutterBinaryMessenger used for communication with Flutter.
     * @param viewController The current UIViewController context.
     * @param libreMap The MLNMapView instance.
     */
    init(binaryMessenger: FlutterBinaryMessenger, libreView: MLNMapView) {
        self.binaryMessenger = binaryMessenger
        self.libreView = libreView
    }
    
    /**
     * Downloads a region for offline use based on provided arguments.
     *
     * This function takes a dictionary of arguments containing the region's definition and metadata,
     * parses them, and then initiates the offline download using the LibreOfflineManager.
     *
     * @param args A dictionary containing the following keys:
     *  - "definition": A dictionary describing the offline region definition.
     *  - "metadata": A dictionary containing metadata associated with the offline region.
     */
    func download(args: [String : Any?], completion: @escaping (Result<[AnyHashable? : Any?], any Error>) -> Void) {
        // Download Progress Event Listener
        let progressEventListener = DownloadProgressEventListener()
        
        // Setting stream handler
        StreamEventsStreamHandler.register(with: binaryMessenger, streamHandler: progressEventListener)
        
        // Creating unique id to associate with offline region downloaded
        let uniqueId = IdUtils.rand4() + IdUtils.rand4()
        
        do {
            // Definition
            guard let definitionArgs = args["definition"] as? [AnyHashable: Any] else {
                throw NSError(domain: "NaxaLibreOfflineManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid 'definition' in arguments"])
            }
            
            let definition = OfflineRegionDefinitionArgsParser.parseArgs(
                args: definitionArgs, libreView: libreView
            )
            
            // Metadata
            guard var metadataArgs = args["metadata"] as? [AnyHashable: Any] else {
                throw NSError(domain: "NaxaLibreOfflineManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Missing or invalid 'metadata' in arguments"])
            }
            
            // Adding id to the metadata
            metadataArgs["id"] = uniqueId
            
            // Creating metadata data from the metadata args map
            let metadataData = try JSONSerialization.data(withJSONObject: metadataArgs, options: [])
            
            // Creating Offline Region
            libreOfflineManager.addPack(for: definition, withContext: metadataData) { (offlinePack, error) in
                if let error = error {
                    progressEventListener.onError(error: error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                guard let offlinePack = offlinePack else {
                    let error = NSError(domain: "NaxaLibreOfflineManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to create offline pack"])
                    progressEventListener.onError(error: error.localizedDescription)
                    completion(.failure(error))
                    return
                }
                
                // Triggering success event
                completion(.success(self.regionAsArgs(region: offlinePack)))
                
                // Triggering on started download event
                progressEventListener.onDownloadStarted(id: uniqueId)
                
                // Add region to downloading regions
                self.downloadingRegions[uniqueId] = offlinePack
                
                // Set observer for download progress
                NotificationCenter.default.addObserver(forName: .MLNOfflinePackProgressChanged, object: offlinePack, queue: OperationQueue.main) { [weak self] notification in
                    guard let offlinePack = notification.object as? MLNOfflinePack else { return }
                    
                    // Calculate the download progress
                    let requiredResources = Double(offlinePack.progress.countOfResourcesExpected)
                    let progress = requiredResources > 0 ? Double(offlinePack.progress.countOfResourcesCompleted) / requiredResources : 0.0
                    
                    // Triggering on downloading event
                    progressEventListener.onDownloading(progress: progress)
                    
                    // If download is complete, trigger onDownloaded event
                    if offlinePack.state == .complete {
                        // Download complete
                        progressEventListener.onDownloaded()
                        NotificationCenter.default.removeObserver(self as Any, name: .MLNOfflinePackProgressChanged, object: offlinePack)
                        self?.downloadingRegions.removeValue(forKey: uniqueId)
                    }
                }
                
                // Set observer for download errors
                NotificationCenter.default.addObserver(forName: .MLNOfflinePackError, object: offlinePack, queue: OperationQueue.main) { [weak self] notification in
                    guard let offlinePack = notification.object as? MLNOfflinePack,
                          let userInfo = notification.userInfo,
                          let error = userInfo[MLNOfflinePackUserInfoKey.error] as? Error else { return }
                    
                    progressEventListener.onError(error: error.localizedDescription)
                    NotificationCenter.default.removeObserver(self as Any, name: .MLNOfflinePackProgressChanged, object: offlinePack)
                    NotificationCenter.default.removeObserver(self as Any, name: .MLNOfflinePackError, object: offlinePack)
                    self?.downloadingRegions.removeValue(forKey: uniqueId)
                }
                
                // Start the download
                offlinePack.resume()
                
            }
        } catch {
            progressEventListener.onError(error: "Failed to start download: \(error.localizedDescription)")
            downloadingRegions.removeValue(forKey: uniqueId)
            completion(.failure(error))
        }
    }
    
    /**
     * Cancels the download of an offline region with the given ID.
     *
     * @param id The unique identifier of the offline region to cancel.
     * @param callback A closure that is called with the result of the cancellation attempt.
     */
    func cancelDownload(id: Int64, completion: @escaping (Result<Bool, any Error>) -> Void) {
        if let region = downloadingRegions[id] {
            region.suspend()
            NotificationCenter.default.removeObserver(self, name: .MLNOfflinePackProgressChanged, object: region)
            NotificationCenter.default.removeObserver(self, name: .MLNOfflinePackError, object: region)
            completion(.success(true))
        } else {
            completion(.failure(
                NSError(
                    domain: "NaxaLibreOfflineManager",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "No pack downloading with the specified id"]
                )
            ))
        }
    }
    
    /**
     * Retrieves an offline region from the LibreOfflineManager by its ID.
     *
     * @param id The ID of the offline region to retrieve.
     * @param callback A closure that will be invoked with the result of the operation.
     */
    func getRegion(id: Int64, completion: @escaping (Result<[AnyHashable? : Any?], any Error>) -> Void) {
        // Guard to check if packs exist
        guard let packs = libreOfflineManager.packs else {
            completion(.failure(
                NSError(
                    domain: "NaxaLibreOfflineManager",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "No pack found with the specified id"]
                )
            ))
            return
        }
        
        // Getting the pack matching given pack id
        guard let pack = packs.first(where: { pack in
            if let packId = idOfPack(of: pack) {
                return packId == id
            }
            return false
        }) else {
            completion(.failure(
                NSError(
                    domain: "NaxaLibreOfflineManager",
                    code: 404,
                    userInfo:
                        [NSLocalizedDescriptionKey: "No pack found with the specified id"]
                )
            ))
            return
        }
        
        // Finally complete with success
        completion(.success(regionAsArgs(region: pack)))
    }
    
    /**
     * Lists all currently available offline regions.
     *
     * @param callback A closure that will be invoked with the result of the operation.
     */
    func listRegions(completion: @escaping (Result<[[AnyHashable? : Any?]], any Error>) -> Void) {
        // Guard to check if packs exist
        guard let packs = libreOfflineManager.packs else {
            completion(.failure(
                NSError(
                    domain: "NaxaLibreOfflineManager",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "No regions found"]
                )
            ))
            return
        }
        
        let regions: [[AnyHashable? : Any?]] = packs.compactMap { pack in
            return regionAsArgs(region: pack)
        }
        
        completion(.success(regions))
    }
    
    /**
     * Deletes an offline region with the specified ID.
     *
     * @param id The ID of the offline region to delete.
     * @param callback A closure that receives the result of the deletion attempt.
     */
    func deleteRegion(id: Int64, completion: @escaping (Result<Bool, any Error>) -> Void) {
        // Guard to check if packs exist
        guard let packs = libreOfflineManager.packs else {
            completion(.failure(
                NSError(
                    domain: "NaxaLibreOfflineManager",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "No regions found"]
                )
            ))
            return
        }
        
        // Guard to check if pack exist with given id for delete
        guard let packToDelete = packs.first(where: { idOfPack(of: $0) == id }) else {
            completion(.failure(
                NSError(
                    domain: "NaxaLibreOfflineManager",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Region not found with the specified id"]
                )
            ))
            return
        }
        
        // Suspend pack if currently downloading
        packToDelete.suspend()
        
        // Finally deleting pack
        libreOfflineManager.removePack(packToDelete) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }
    }
    
    /**
     * Deletes all offline regions managed by the libreOfflineManager.
     *
     * @param callback A closure that receives the result of the operation.
     */
    func deleteAllRegions(completion: @escaping (Result<[Int64 : Bool], any Error>) -> Void) {
        // Guard to check if packs exist
        guard let packs = libreOfflineManager.packs else {
            completion(.failure(
                NSError(
                    domain: "NaxaLibreOfflineManager",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "No regions found"]
                )
            ))
            return
        }
        
        var response = [Int64: Bool]()
        let dispatchGroup = DispatchGroup()
        
        for pack in packs {
            dispatchGroup.enter()
            
            if let id = idOfPack(of: pack) {
                self.libreOfflineManager.removePack(pack) { error in
                    if error != nil {
                        response[id] = false
                    } else {
                        response[id] = true
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(response))
        }
    }
    
    /**
     * Converts an MLNOfflinePack object into a dictionary of arguments suitable for inter-process communication or data serialization.
     *
     * @param region The MLNOfflinePack object to convert.
     * @return A dictionary containing the region's ID, definition details, and metadata.
     */
    private func regionAsArgs(region pack: MLNOfflinePack) -> [AnyHashable?: Any?] {
        
        // Getting id of the given pack
        let id = idOfPack(of: pack)
        
        // Getting metadata from region
        let metadata = pack.context
        
        // Convert Data to dictionary
        var metadataMap: [AnyHashable: Any] = [:]
        if let metadataObj = try? JSONSerialization.jsonObject(with: metadata, options: []) as? [AnyHashable: Any] {
            metadataMap = metadataObj
        }
        
        // Converting definition to map
        var definition: [String: Any?] = [
            "styleUrl": pack.region.styleURL.absoluteString,
            "pixelRatio": Double(UIScreen.main.scale)
        ]
        
        // If region definition is MLNShapeOfflineRegion
        // Adding geometry to definition
        // Else adding bounds to definition
        if let shapeRegion = pack.region as? MLNShapeOfflineRegion {
            
            definition["minZoom"] = shapeRegion.minimumZoomLevel
            definition["maxZoom"] = shapeRegion.maximumZoomLevel
            
            let jsonData = shapeRegion.shape.geoJSONData(usingEncoding: String.Encoding.utf8.rawValue)
            
            do {
                // Convert Data to Dictionary
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                // Cast to the desired type: [AnyHashable?: Any?]
                if let dictionary = jsonObject as? [AnyHashable?: Any?] {
                    definition["geometry"] = dictionary
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        
        } else if let tileRegion = pack.region as? MLNTilePyramidOfflineRegion {
            let bounds = tileRegion.bounds
            definition["bounds"] = [
                bounds.sw.longitude,
                bounds.sw.latitude,
                bounds.ne.longitude,
                bounds.ne.latitude
            ]
            
            definition["minZoom"] = tileRegion.minimumZoomLevel
            definition["maxZoom"] = tileRegion.maximumZoomLevel
            definition["includeIdeographs"] = tileRegion.includesIdeographicGlyphs
        }
        
        // Creating final response
        let response: [AnyHashable?: Any?] = [
            "id": id,
            "definition": definition,
            "metadata": metadataMap
        ]
        
        // Returning response
        return response
    }
    
    /**
     * Extracts the identifier from an MLNOfflinePack's context.
     *
     * This method attempts to deserialize the pack's context data into a dictionary
     * and retrieve the integer value associated with the "id" key.
     *
     * @param pack The MLNOfflinePack from which to extract the identifier
     * @return The integer identifier of the pack if available, nil otherwise
     */
    private func idOfPack(of pack: MLNOfflinePack) -> Int64? {
        if let contextDict = try? JSONSerialization.jsonObject(with: pack.context, options: []) as? [AnyHashable:Any],
            let packId = contextDict["id"] as? Int64 {
            return packId
        }
        
        return nil
    }
    
    /**
     * A class to handle download progress events and communicate them to Flutter.
     */
    private class DownloadProgressEventListener: StreamEventsStreamHandler {
        private var eventSink: PigeonEventSink<NaxaLibreEvent>?
        
        override func onCancel(withArguments arguments: Any?) {
            self.eventSink = nil
        }
        
        override func onListen(withArguments arguments: Any?, sink: PigeonEventSink<NaxaLibreEvent>) {
            self.eventSink = sink
        }
        
        func onDownloadStarted(id: Int64) {
            eventSink?.success(IntEvent(data: id))
        }
        
        func onDownloading(progress: Double) {
            eventSink?.success(DoubleEvent(data: progress))
        }
        
        func onError(error: String) {
            eventSink?.error(code: "DOWNLOAD_ERROR", message: error, details: nil)
        }
        
        func onDownloaded() {
            eventSink?.endOfStream()
            eventSink = nil
        }
    }
    
    deinit {
        // Remove all observers
        NotificationCenter.default.removeObserver(self)
    }
}
