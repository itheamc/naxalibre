//
//  MapLibreView.swift
//  naxalibre
//
//  Created by Amit on 24/01/2025.
//

import Flutter
import UIKit
import MapLibre

public class NaxaLibrePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "naxalibre", binaryMessenger: registrar.messenger())
        let instance = NaxaLibrePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Register a platform view factory for embedding a MapLibre view
        let factory = MapLibreViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "naxalibre/mapview")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getPlatformVersion":
                result("iOS " + UIDevice.current.systemVersion)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}


