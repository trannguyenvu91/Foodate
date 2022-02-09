//
//  LocationManager+Mock.swift
//  Foodate
//
//  Created by Vu Tran on 1/13/22.
//

import CoreLocation

enum UpdatingLocationResult {
    case success(CLLocation)
    case error(Error)
}

class MockLocationManager: LocationManager {
    
    var delegate: CLLocationManagerDelegate?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var _updatingLocationResult: UpdatingLocationResult = .error(LocationError.notAvailable)
    var _willChangeAuthorizationStatus: CLAuthorizationStatus? = nil
    
    func startUpdatingLocation() {
        switch _updatingLocationResult {
        case .success(let cLLocation):
            delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [cLLocation])
        case .error(let error):
            delegate?.locationManager?(CLLocationManager(), didFailWithError: error)
        }
    }
    
    func requestWhenInUseAuthorization() {
        if let _willChangeAuthorizationStatus = _willChangeAuthorizationStatus {
            authorizationStatus = _willChangeAuthorizationStatus
        }
        delegate?.locationManagerDidChangeAuthorization?(CLLocationManager())
    }
    
}
