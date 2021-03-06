//
//  Tests_LocationService.swift
//  Foodate
//
//  Created by Vu Tran on 1/13/22.
//

import XCTest

class Tests_LocationService: BaseTestCase {

    func testStatusNotDetermined() async throws {
        locationManager.authorizationStatus = .notDetermined
        locationManager._willChangeAuthorizationStatus = .authorizedWhenInUse
        locationManager._updatingLocationResult = .success(.init(latitude: 9, longitude: 10))
        let location = try await locationService.requestLocation()
        XCTAssertNotNil(location)
        XCTAssertEqual(location.coordinate.latitude, 9)
        XCTAssertEqual(location.coordinate.longitude, 10)
    }
    
    func testStatusAuthorized() async throws {
        locationManager.authorizationStatus = .authorizedWhenInUse
        locationManager._updatingLocationResult = .success(.init(latitude: 9, longitude: 10))
        let location = try await locationService.requestLocation()
        XCTAssertNotNil(location)
        XCTAssertEqual(location.coordinate.latitude, 9)
        XCTAssertEqual(location.coordinate.longitude, 10)
    }
    
    func testStatusDenied() async throws {
        locationManager.authorizationStatus = .denied
        locationManager._updatingLocationResult = .error(LocationError.notGranted)
        do {
            let _ = try await locationService.requestLocation()
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdatingError() async throws {
        locationManager.authorizationStatus = .notDetermined
        locationManager._willChangeAuthorizationStatus = .authorizedWhenInUse
        locationManager._updatingLocationResult = .error(LocationError.notAvailable)
        do {
            let _ = try await locationService.requestLocation()
        } catch {
            XCTAssertNotNil(error)
        }
    }

}
