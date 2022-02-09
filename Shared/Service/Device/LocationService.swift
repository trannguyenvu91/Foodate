//
//  LocationService.swift
//  Foodate
//
//  Created by Vu Tran on 12/28/21.
//

import Foundation
import CoreLocation
import CoreStore

protocol LocationManager {
    func startUpdatingLocation()
    func requestWhenInUseAuthorization()
    var delegate: CLLocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
}

extension LocationManager {
    var isPermissionGranted: Bool {
        authorizationStatus == .authorizedAlways ||
        authorizationStatus == .authorizedWhenInUse
    }
    
}

extension LocationManager where Self == CLLocationManager {
    
    static var standard: LocationManager {
        let manager = CLLocationManager()
        manager.allowsBackgroundLocationUpdates = false
        return manager
    }
    
}

extension CLLocationManager: LocationManager {}


class LocationService: NSObject, CLLocationManagerDelegate {
    static var shared: LocationService!
    private(set) var manager: LocationManager
    private var queueCallbacks = [LocationCallback]()
    private var lastLocation: CLLocation?
    typealias LocationCallback = (CLLocation?, Error?) -> Void

    init(_ manager: LocationManager) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }
    
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
    
    func locationManagerDidChangeAuthorization(_ aManager: CLLocationManager) {
        guard manager.isPermissionGranted else {
            didReceive(nil, error: LocationError.notGranted)
            return
        }
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ aManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        didReceive(lastLocation, error: nil)
    }
    
    func locationManager(_ aManager: CLLocationManager, didFailWithError error: Error) {
        didReceive(nil, error: error)
    }
    
}
