//
//  NaxaLibreLocationManager.swift
//  naxalibre
//
//  Created by Amit on 25/02/2025.
//

import Foundation
import MapLibre
import CoreLocation

/// A custom implementation of `MLNLocationManager` that wraps `CLLocationManager` to provide
/// location and heading updates for a MapLibre map (`MGLMapView`).
class NaxaLibreLocationManager: NSObject, MLNLocationManager, CLLocationManagerDelegate {
    // MARK: - Private Properties
    
    /// The underlying `CLLocationManager` used to manage location updates.
    private let locationManager = CLLocationManager()
    
    // MARK: - MLNLocationManager Protocol
    
    /// The delegate that receives location and heading updates from this manager.
    weak var delegate: MLNLocationManagerDelegate?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Location Properties
    
    /// Returns the current authorization status for location services.
    var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    /// Returns the current accuracy authorization level for location services.
    var accuracyAuthorization: CLAccuracyAuthorization {
        if #available(iOS 14.0, *) {
            return locationManager.accuracyAuthorization
        } else {
            return .fullAccuracy
        }
    }
    
    /// The device orientation used for heading updates.
    var headingOrientation: CLDeviceOrientation {
        get { return locationManager.headingOrientation }
        set { locationManager.headingOrientation = newValue }
    }
    
    // MARK: - Location Authorization
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestTemporaryFullAccuracyAuthorization(withPurposeKey purposeKey: String) {
        if #available(iOS 14.0, *) {
            locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposeKey)
        }
    }
    
    // MARK: - Location Updates
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Heading Updates
    
    func startUpdatingHeading() {
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdatingHeading() {
        locationManager.stopUpdatingHeading()
    }
    
    func dismissHeadingCalibrationDisplay() {
        locationManager.dismissHeadingCalibrationDisplay()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationManager(self, didUpdate: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        delegate?.locationManager(self, didUpdate: newHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationManager(self, didFailWithError: error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.locationManagerDidChangeAuthorization(self)
    }
    
    // MARK: Apply Location Settings From Args
    
    func applyLocationSettings(_ settings: NaxaLibreLocationSettings) {
        let options = settings.locationEngineRequestOptions
        
        // Desired Accuracy
        switch options.priority {
            case .lowPower:
                if #available(iOS 14.0, *) {
                    locationManager.desiredAccuracy = kCLLocationAccuracyReduced
                } else {
                    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                }
            case .balanced:
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
            case .highAccuracy:
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            default:
                // Handle any unexpected cases or provide a default accuracy
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        // Distance Filter
        locationManager.distanceFilter = options.displacement
    }
}
