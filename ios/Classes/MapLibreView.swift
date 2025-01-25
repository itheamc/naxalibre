//
//  MapLibreView.swift
//  naxalibre
//
//  Created by Amit on 24/01/2025.
//

import Flutter
import UIKit
import MapLibre

class MapLibreView: NSObject, FlutterPlatformView {
    private var mapView: MLNMapView
    
    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger, args: Any?) {
        self.mapView = MLNMapView(frame: frame)
        super.init()
        
        let controller: NaxaLibreController = NaxaLibreController(binaryMessenger: messenger, libreView: mapView)
        
        if let arguments = args as? [String: Any] {
            if let styleURL = arguments["styleURL"] as? String {
                self.mapView.styleURL = URL(string: styleURL)
            }
        }
    }
    
    func view() -> UIView {
        return mapView
    }
}
