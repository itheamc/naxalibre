//
//  MapLibreViewFactory.swift
//  Pods
//
//  Created by Amit on 24/01/2025.
//
import Flutter
import UIKit
import MapLibre


class MapLibreViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return MapLibreView(frame: frame, viewId: viewId, messenger: messenger, args: args)
    }
}
