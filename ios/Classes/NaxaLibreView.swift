//
//  NaxaLibreView.swift
//  naxalibre
//
//  Created by Amit on 24/01/2025.
//

import Flutter
import UIKit
import MapLibre

class NaxaLibreView: NSObject, FlutterPlatformView {
    private var libreView: MLNMapView
    private var messenger: FlutterBinaryMessenger
    private var controller: NaxaLibreController?
    private var observers: [NSObjectProtocol] = []
    
    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger, args: Any?) {
        self.libreView = MLNMapView(frame: frame)
        self.messenger = messenger
        super.init()
        
        self.controller = NaxaLibreController(binaryMessenger: messenger, libreView: libreView, args: args)
        controller?.naxaLibreListeners.register()
        setupLifecycleObservers()
    }
    
    func view() -> UIView {
        return libreView
    }
    
    // MARK: - Lifecycle Observers
    private func setupLifecycleObservers() {
        let notifications: [(Notification.Name, (NaxaLibreView) -> Void)] = [
            (UIApplication.willEnterForegroundNotification, { $0.onForeground() }),
            (UIApplication.didBecomeActiveNotification, { $0.onResume() }),
            (UIApplication.willResignActiveNotification, { $0.onPause() }),
            (UIApplication.didEnterBackgroundNotification, { $0.onBackground() }),
            (UIApplication.willTerminateNotification, { $0.onTerminate() })
        ]
        
        notifications.forEach { name, handler in
            let observer = NotificationCenter.default.addObserver(
                forName: name,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                handler(self)
            }
            observers.append(observer)
        }
    }
    
    // MARK: - Lifecycle Handlers
    private func onForeground() {}
    
    private func onResume() {
        controller?.naxaLibreListeners.register()
    }
    
    private func onPause() {}
    
    private func onBackground() {
        controller?.naxaLibreListeners.unregister()
    }
    
    private func onTerminate() {}
    
    // MARK: - Cleanup
    func dispose() {
        // Remove all observers
        observers.forEach(NotificationCenter.default.removeObserver)
        observers.removeAll()
        
        // Release map resources
        libreView.removeFromSuperview()
        libreView = MLNMapView(frame: .zero)
        
        // Cleanup controller
        controller = nil
    }
    
    deinit {
        dispose()
    }
    
}
