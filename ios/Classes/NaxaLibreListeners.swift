//
//  NaxaLibreListeners.swift
//  naxalibre
//
//  Created by Amit on 18/02/2025.
//

import Foundation
import Flutter
import MapLibre

class NaxaLibreListeners: NSObject, MLNMapViewDelegate, UIGestureRecognizerDelegate {
    private let binaryMessenger: FlutterBinaryMessenger
    private let libreView: MLNMapView
    private let libreAnnotationsManager: NaxaLibreAnnotationsManager
    private let args: Any?
    
    // MARK: NaxaLibreFlutterApi
    // For handling flutter callbacks
    private lazy var flutterApi = NaxaLibreFlutterApi(binaryMessenger: binaryMessenger)
    
    // MARK: Initialization / Constructor
    init(binaryMessenger: FlutterBinaryMessenger, libreView: MLNMapView, libreAnnotationsManager: NaxaLibreAnnotationsManager, args: Any?) {
        self.binaryMessenger = binaryMessenger
        self.libreView = libreView
        self.libreAnnotationsManager = libreAnnotationsManager
        self.args = args
        super.init()
    }
    
    // MARK: Tap Gesture Recognizers
    private lazy var singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
    private lazy var longTap = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(sender:)))
    
    
    // MARK: Drag Gesture Recognizer
    private lazy var dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
    
    // MARK: Rotation Gesture Recognizer
    private lazy var rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
    
    // MARK: Method to register all gestures / listeners
    func register() {
        libreView.delegate = self
        registerTapGestures()
        registerDragGesture()
        registerRotationGesture()
    }
    
    // MARK: Method to unregister all gestures / listeners
    func unregister() {
        libreView.delegate = nil
        unregisterTapGestures()
        unregisterDragGesture()
        unregisterRotationGesture()
    }
    
    // MARK: Handler for Tap Gesture Recognizers
    // Method to register tap gestures
    // In this method single and long tap gesture are registered
    private func registerTapGestures() {
        longTap.minimumPressDuration = 0.1
        
        if let existingRecognizers = libreView.gestureRecognizers {
            for recognizer in existingRecognizers {
                // Handle existing tap recognizers
                if let tapRecognizer = recognizer as? UITapGestureRecognizer {
                    singleTap.require(toFail: tapRecognizer)
                }
                
                // Handle existing long press recognizers
                if let existingLongPress = recognizer as? UILongPressGestureRecognizer {
                    longTap.require(toFail: existingLongPress)
                }
            }
        }
        
        singleTap.delegate = self
        longTap.delegate = self
        libreView.addGestureRecognizer(singleTap)
        libreView.addGestureRecognizer(longTap)
    }
    
    // Method to unregister tap gestures
    private func unregisterTapGestures() {
        libreView.removeGestureRecognizer(singleTap)
        libreView.removeGestureRecognizer(longTap)
    }
    
    // Single Tap Gesture Listeners
    @objc private func handleMapTap(sender: UITapGestureRecognizer) {
        guard let view = sender.view as? MLNMapView else { return }
        let point = sender.location(in: view)
        
        let (annotationAtLatLng, properties) = libreAnnotationsManager.isAnnotationAtPoint(point)
        
        if annotationAtLatLng {
            flutterApi.onAnnotationClick(annotation: properties!, completion: { _ in })
            return
        }
        
        let latLng = view.convert(point, toCoordinateFrom: nil)
        flutterApi.onMapClick(latLng: [latLng.latitude, latLng.longitude], completion: { _ in })
    }
    
    // Long Tap Gesture Listeners
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let view = sender.view as? MLNMapView else { return }
            let point = sender.location(in: view)
            
            let (annotationAtLatLng, properties) = libreAnnotationsManager.isAnnotationAtPoint(point)
            
            if annotationAtLatLng {
                
                if libreAnnotationsManager.isDraggable(properties) {
                    
                    libreAnnotationsManager.removeAnnotationDragListeners()
                    libreAnnotationsManager.addAnnotationDragListener { id, type, annotation, updatedAnnotation, event in
                        self.flutterApi.onAnnotationDrag(
                            id: id,
                            type: type.rawValue,
                            geometry: annotation.toGeometryJson(),
                            updatedGeometry: updatedAnnotation.toGeometryJson(),
                            event: event,
                            completion: {_ in }
                        )
                    }
                    
                    libreAnnotationsManager.handleDragging(properties!)
                }
                
                flutterApi.onAnnotationLongClick(annotation: properties!, completion: { _ in })
                return
            }
            
            let latLng = view.convert(point, toCoordinateFrom: nil)
            flutterApi.onMapLongClick(latLng: [latLng.latitude, latLng.longitude], completion: { _ in })
        }
    }
    
    // MARK: Handler for Drag Gesture Recognizer
    // Method to register drag gesture
    private func registerDragGesture() {
        if let existingRecognizers = libreView.gestureRecognizers {
            for recognizer in existingRecognizers {
                // Handle existing pan recognizers
                if let panRecognizer = recognizer as? UIPanGestureRecognizer {
                    dragGesture.require(toFail: panRecognizer)
                }
            }
        }
        
        dragGesture.delegate = self
        libreView.addGestureRecognizer(dragGesture)
    }
    
    // Method to unregister drag gesture
    private func unregisterDragGesture() {
        libreView.removeGestureRecognizer(dragGesture)
    }
    
    // Drag Gesture Listener
    @objc private func handleDrag(sender: UIPanGestureRecognizer) {
        // let location = sender.location(in: libreView)
        // let translation = sender.translation(in: libreView)
        let velocity = sender.velocity(in: libreView)
        
        switch sender.state {
            case .began:
                break
            case .changed:
                break
            case .ended:
                if max(abs(velocity.x), abs(velocity.y)) > 1000 {
                    flutterApi.onFling(completion: { _ in })
                }
            default:
                break
        }
    }
    
    // MARK: Handler for Rotation Gesture Recognizer
    
    // Variables for handling rotation gestures
    private var startRotation: CGFloat = 0
    private var lastRotation: CGFloat = 0
    
    // Method to register rotation gesture
    private func registerRotationGesture() {
        if let existingRecognizers = libreView.gestureRecognizers {
            for recognizer in existingRecognizers {
                // Handle existing rotation recognizers
                if let rotationRecognizer = recognizer as? UIRotationGestureRecognizer {
                    rotationGesture.require(toFail: rotationRecognizer)
                }
            }
        }
        
        rotationGesture.delegate = self
        libreView.addGestureRecognizer(rotationGesture)
    }
    
    // Method to unregister rotation gesture
    private func unregisterRotationGesture() {
        libreView.removeGestureRecognizer(rotationGesture)
    }
    
    // Rotation Gesture Listener
    @objc private func handleRotation(sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        
        switch sender.state {
            case .began:
                startRotation = rotation
                lastRotation = rotation
                flutterApi.onRotateStarted(
                    angleThreshold: Double(rotation),
                    deltaSinceStart: 0.0,
                    deltaSinceLast: 0.0,
                    completion: { _ in }
                )
            case .changed:
                let deltaSinceStart = rotation - startRotation
                let deltaSinceLast = rotation - lastRotation
                lastRotation = rotation
                
                flutterApi.onRotateStarted(
                    angleThreshold: Double(rotation),
                    deltaSinceStart: Double(deltaSinceStart),
                    deltaSinceLast: Double(deltaSinceLast),
                    completion: { _ in }
                )
            case .ended, .cancelled, .failed:
                let deltaSinceStart = rotation - startRotation
                let deltaSinceLast = rotation - lastRotation
                
                flutterApi.onRotateStarted(
                    angleThreshold: Double(rotation),
                    deltaSinceStart: Double(deltaSinceStart),
                    deltaSinceLast: Double(deltaSinceLast),
                    completion: { _ in }
                )
                
                // Reset values after gesture ends
                startRotation = 0
                lastRotation = 0
                
            default:
                break
        }
    }
    
    // MARK: MLNMapViewDelegate Overrides
    
    func mapViewDidFinishRenderingMap(_ mapView: MLNMapView, fullyRendered: Bool) {
        flutterApi.onMapRendered(completion: { _ in})
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MLNMapView) {
        flutterApi.onMapLoaded(completion: { _ in})
    }
    
    func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
        flutterApi.onStyleLoaded(completion: { _ in})
    }
    
    func mapViewDidBecomeIdle(_ mapView: MLNMapView) {
        flutterApi.onCameraIdle(completion: { _ in})
    }
    
    func mapView(_ mapView: MLNMapView, regionWillChangeWith reason: MLNCameraChangeReason, animated: Bool) {
        flutterApi.onCameraMoveStarted(reason: reason.toFlutterCode(), completion: { _ in})
    }
    
    func mapView(_ mapView: MLNMapView, regionIsChangingWith reason: MLNCameraChangeReason) {
        flutterApi.onCameraMove(completion: { _ in})
    }
    
    func mapView(_ mapView: MLNMapView, regionDidChangeWith reason: MLNCameraChangeReason, animated: Bool) {
        flutterApi.onCameraMoveEnd(completion: { _ in})
    }
    
    func mapView(styleForDefaultUserLocationAnnotationView mapView: MLNMapView) -> MLNUserLocationAnnotationViewStyle {
        
        let style = MLNUserLocationAnnotationViewStyle()
        
        if let creationArgs = args as? [String: Any?] {
            if let locationSettingArgs = creationArgs["locationSettings"] as? [String: Any?] {
                let styleOptions = NaxaLibreLocationSettingsArgsParser
                    .parseArgs(locationSettingArgs)
                    .locationComponentOptions
                
                style.applyStyle(styleOptions)
            }
        }
        
        return style
    }
    
    // MARK: - UIGestureRecognizerDelegate
    @MainActor
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // Allow simultaneous recognition of tap and pan gestures
        if gestureRecognizer is UITapGestureRecognizer || otherGestureRecognizer is UITapGestureRecognizer {
            return true
        }
        
        if gestureRecognizer is UIRotationGestureRecognizer || otherGestureRecognizer is UIRotationGestureRecognizer {
            return true
        }
        
        if gestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer is UIPanGestureRecognizer {
            return true
        }
        
        // Default behavior: do not allow simultaneous recognition
        return false
    }
    
}
