//
//  NaxaLibreListeners.swift
//  naxalibre
//
//  Created by Amit on 18/02/2025.
//

import Foundation
import Flutter
import MapLibre

class NaxaLibreListeners: NSObject, MLNMapViewDelegate {
    private let binaryMessenger: FlutterBinaryMessenger
    private let libreView: MLNMapView
    
    // MARK: NaxaLibreFlutterApi
    // For handling flutter callbacks
    private lazy var flutterApi = NaxaLibreFlutterApi(binaryMessenger: binaryMessenger)
    
    // MARK: Initialization / Constructor
    init(binaryMessenger: FlutterBinaryMessenger, libreView: MLNMapView) {
        self.binaryMessenger = binaryMessenger
        self.libreView = libreView
        super.init()
        
        libreView.delegate = self
    }
    
    // MARK: Tap Gesture Recognizers
    private lazy var singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
    private lazy var longTap = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(sender:)))
    
    
    // MARK: Drag Gesture Recognizers
    private lazy var dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
    
    // Method to register all gestures / listeners
    func registerAllGestures() {
        registerTapGestures()
        registerDragGesture()
    }
    
    // Method to unregister all gestures / listeners
    func unregisterAllGestures() {
        unregisterTapGestures()
        unregisterDragGesture()
    }
    
    // MARK: Handler for Tap Gesture Recognizers
    // Method to register tap gestures
    // In this method single and long tap gesture are registered
    private func registerTapGestures() {
        longTap.minimumPressDuration = 0.5
        
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
        // Handle single tap
        let location = sender.location(in: libreView)
        print("[NaxaLibreListeners] Single tap detected at: \(location)")
    }
    
    // Long Tap Gesture Listeners
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        // Only handle the beginning of the long press
        if sender.state == .began {
            // Handle long press
            let location = sender.location(in: libreView)
            print("[NaxaLibreListeners] Long press detected at: \(location)")
        }
    }
    
    // MARK: Handler for Drag Gesture Recognizer
    // Method to register drag gesture
    private func registerDragGesture() {
        if let existingRecognizers = libreView.gestureRecognizers {
            for recognizer in existingRecognizers {
                // Handle existing pan recognizers
                if let panRecognizer = recognizer as? UIPanGestureRecognizer {
                    singleTap.require(toFail: panRecognizer)
                }
            }
        }
        
        libreView.addGestureRecognizer(dragGesture)
    }
    
    // Method to unregister drag gesture
    private func unregisterDragGesture() {
        libreView.removeGestureRecognizer(dragGesture)
    }
    
    // Drag Gesture Listener
    @objc private func handleDrag(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: libreView)
        let translation = sender.translation(in: libreView)
        let velocity = sender.velocity(in: libreView)
        
        switch sender.state {
            case .began:
                print("[NaxaLibreListeners] Drag began at: \(location)")
            case .changed:
                print("[NaxaLibreListeners] Dragging at: \(location), translation: \(translation), velocity: \(velocity)")
            case .ended:
                print("[NaxaLibreListeners] Drag ended at: \(location)")
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
    
}
