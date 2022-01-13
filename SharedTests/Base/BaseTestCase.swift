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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        try FDCoreStore.shared.setup(.test)
        let mockService = MockNetworkService()
        NetworkService.shared = mockService
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
