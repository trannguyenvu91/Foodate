//
//  BaseTestCase.swift
//  Foodate
//
//  Created by Vu Tran on 1/12/22.
//

import XCTest
import Combine

class BaseTestCase: XCTestCase {
    
    var cancelableSet = [AnyCancellable]()
    let networkService = MockNetworkService()
    let locationManager = MockLocationManager()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        LocationService.shared = LocationService(locationManager)
        try FDCoreStore.shared.setup(.test)
        NetworkService.shared = networkService
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
