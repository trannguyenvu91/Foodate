//
//  Tests_LocationService.swift
//  Foodate
//
//  Created by Vu Tran on 1/13/22.
//

import XCTest

class Tests_LocationService: BaseTestCase {
    
    let service = LocationService()
    let manager = MockLocationManager()

    override func setUpWithError() throws {
        service.manager = manager
        manager.delegate = service
    }

    override func tearDownWithError() throws {}

    func testStatusNotDetermined() async throws {
        manager._authorizationStatus = .notDetermined
        manager._willChangeAuthorizationStatus = .authorizedWhenInUse
        manager._updatingLocationResult = .success(.init(latitude: 9, longitude: 10))
        let location = try await service.requestLocation()
        XCTAssertNotNil(location)
        XCTAssertEqual(location.coordinate.latitude, 9)
        XCTAssertEqual(location.coordinate.longitude, 10)
    }
    
    func testStatusAuthorized() async throws {
        manager._authorizationStatus = .authorizedWhenInUse
        manager._updatingLocationResult = .success(.init(latitude: 9, longitude: 10))
        let location = try await service.requestLocation()
        XCTAssertNotNil(location)
        XCTAssertEqual(location.coordinate.latitude, 9)
        XCTAssertEqual(location.coordinate.longitude, 10)
    }
    
    func testStatusDenied() async throws {
        manager._authorizationStatus = .denied
        manager._updatingLocationResult = .error(LocationError.notGranted)
        do {
            let _ = try await service.requestLocation()
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdatingError() async throws {
        manager._authorizationStatus = .notDetermined
        manager._willChangeAuthorizationStatus = .authorizedWhenInUse
        manager._updatingLocationResult = .error(LocationError.notAvailable)
        do {
            let _ = try await service.requestLocation()
        } catch {
            XCTAssertNotNil(error)
        }
    }

}
