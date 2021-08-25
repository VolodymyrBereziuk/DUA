//
//  LocationManager.swift
//  DostupnoUA
//
//  Created by admin on 10.11.2019.
//  Copyright © 2019 DostupnoUA. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftMessages

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager
    var lastLocation: CLLocation?

    var isLocationDetectionFailed = false
    
    var authorizationHandler: ((Bool) -> Void)?
    
    override private init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .fitness
        locationManager.delegate = self
        
        startDetectingLocation()
    }
    
    func checkIsServiceEnabled(completionHandler: @escaping (Bool) -> Void) {
        
        guard CLLocationManager.locationServicesEnabled() else {
            locationManager.requestWhenInUseAuthorization()
            completionHandler(false)
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            locationManager.requestWhenInUseAuthorization()
            completionHandler(false)
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            completionHandler(true)
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
            completionHandler(false)
        }
    }
    
    func startDetectingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopDetectingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    var currentLocation: CLLocation? {
        return locationManager.location
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }
        isLocationDetectionFailed = false
        lastLocation = location
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        guard isLocationDetectionFailed == false else {
            return
        }
        
        SwiftMessages.show(warning: R.string.localizable.genericErrorUnknown.localized())
        
        isLocationDetectionFailed = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationHandler?(true)
        default:
            authorizationHandler?(false)
        }
    }
//    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if (status == CLAuthorizationStatus.denied) {
//            // The user denied authorization
//        } else if (status == CLAuthorizationStatus.authorizedAlways) {
//            // The user accepted authorization
//        }
//    }
    
}
