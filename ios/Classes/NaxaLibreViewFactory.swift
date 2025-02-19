//
//  NaxaLibreViewFactory.swift
//  naxalibre
//
//  Created by Amit on 24/01/2025.
//
import Flutter
import UIKit
import MapLibre


class NaxaLibreViewFactory: NSObject, FlutterPlatformViewFactory {
    private let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func createArgsCodec() -> any FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NaxaLibreView(frame: frame, viewId: viewId, messenger: messenger, args: args)
    }
}
