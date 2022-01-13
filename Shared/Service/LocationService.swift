//
//  LocationService.swift
//  Foodate
//
//  Created by Vu Tran on 12/28/21.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    typealias LocationCallback = (CLLocation?, Error?) -> Void
    static let shared = LocationService()
    lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.allowsBackgroundLocationUpdates = false
        manager.delegate = self
        return manager
    }()
    private var queueCallbacks = [LocationCallback]()
    private var lastLocation: CLLocation?
    
    @MainActor
    func requestLocation() async throws -> CLLocation  {
        try await withCheckedThrowingContinuation { continuation in
            let newBlock: LocationCallback = { location, error in
                guard let location = location else {
                    continuation.resume(throwing: error ?? LocationError.notAvailable)
                    return
                }
                continuation.resume(returning: location)
            }
            queueCallbacks.append(newBlock)
            if let lastLocation = lastLocation {
                didReceive(lastLocation, error: nil)
            } else if manager.isPermissionGranted {
                manager.startUpdatingLocation()
            } else {
                manager.requestWhenInUseAuthorization()
            }
        }
    }
    
    private func didReceive(_ location: CLLocation?, error: Error?) {
        if let location = location {
            lastLocation = location
        }
        for callback in queueCallbacks {
            callback(location, error)
        }
        queueCallbacks.removeAll()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.isPermissionGranted else {
            didReceive(nil, error: LocationError.notGranted)
            return
        }
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        didReceive(lastLocation, error: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didReceive(nil, error: error)
    }
    
}

extension CLLocationManager {
    var isPermissionGranted: Bool {
        authorizationStatus == .authorizedAlways ||
        authorizationStatus == .authorizedWhenInUse
    }
}
