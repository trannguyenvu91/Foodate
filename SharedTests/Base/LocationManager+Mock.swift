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

class MockLocationManager: CLLocationManager {
    var _authorizationStatus: CLAuthorizationStatus = .notDetermined
    var _updatingLocationResult: UpdatingLocationResult = .error(LocationError.notAvailable)
    var _willChangeAuthorizationStatus: CLAuthorizationStatus? = nil
    
    
    override var authorizationStatus: CLAuthorizationStatus {
        _authorizationStatus
    }
    
    override func startUpdatingLocation() {
        switch _updatingLocationResult {
        case .success(let cLLocation):
            delegate?.locationManager?(self, didUpdateLocations: [cLLocation])
        case .error(let error):
            delegate?.locationManager?(self, didFailWithError: error)
        }
    }
    
    override func requestWhenInUseAuthorization() {
        if let _willChangeAuthorizationStatus = _willChangeAuthorizationStatus {
            _authorizationStatus = _willChangeAuthorizationStatus
        }
        delegate?.locationManagerDidChangeAuthorization?(self)
    }
    
}
