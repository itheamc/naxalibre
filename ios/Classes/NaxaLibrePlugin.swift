//
//  NaxaLibrePlugin.swift
//  naxalibre
//
//  Created by Amit on 24/01/2025.
//

import Flutter
import UIKit
import MapLibre

public class NaxaLibrePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = NaxaLibreViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "naxalibre/mapview")
    }
}


