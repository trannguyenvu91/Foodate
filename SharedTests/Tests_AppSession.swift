//
//  Tests_AppFlow.swift
//  Foodate
//
//  Created by Vu Tran on 1/17/22.
//

import XCTest
import CoreStore

class Tests_AppFlow: BaseTestCase {
    
    lazy var sessionJson: JSON = {
        try! Bundle(for: type(of: self))
            .json(forResource: "session_user", ofType: "json")
    }()
    let config = AppFlow()
    let persistance = try? PersistanceService(.test)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        try persistance.deleteAll(Where<FDSessionUser>(true))
        let _ = try FDSessionUser.importObject(from: sessionJson)
        try config.loadSessionUser()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSessionUser() throws {
        let sessionUser = try PersistanceService.shared.fetchOne(Where<FDSessionUser>(true))
        let name = "Vu Tran 123456"
        let location = FDLocation(.init(latitude: 99, longitude: 98))
        try PersistanceService.shared.dataStack.perform { transaction in
            let session = transaction.edit(sessionUser)
            session?.userName = name
            session?.location = location
        }
        XCTAssertEqual(config.sessionUser?.$userName, name)
        XCTAssertEqual(config.sessionUser?.$location, location)
    }
    
    func testLogOut() throws {
        try config.logOut()
        let sessionUser = try PersistanceService.shared.fetchOne(Where<FDSessionUser>(true))
        try config.loadSessionUser()
        XCTAssertNil(sessionUser)
        XCTAssertNil(config.sessionUser)
    }

}
