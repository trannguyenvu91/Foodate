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
    let networkActor = MockNetworkActor()
    let locationManager = MockLocationManager()
    let application = MockApplication()
    let notificationCenter = MockNotificationCenter()
    let appDelegate = AppDelegate()
    
    lazy var persistance = try! PersistanceService(.test)
    lazy var networkService = NetworkService(networkActor)
    lazy var locationService = LocationService(locationManager)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        application.delegate = appDelegate
        LibraryAPI.shared = LibraryAPI(application,
                                       persistance: persistance,
                                       networkService: networkService,
                                       locationService: locationService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
