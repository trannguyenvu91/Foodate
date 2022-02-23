//
//  Tests_BaseObjectViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 1/17/22.
//

import XCTest
import CoreStore

class Tests_BaseObjectViewModel: BaseTestCase {
    
    lazy var objectID: Int = {
        try! MockResponse.invitation.jsonValue["id"] as! Int
    }()
    lazy var model = BaseObjectViewModel<FDInvitation>(objectID)

    override func setUpWithError() throws {
        try super.setUpWithError()
        MockNetworkActor.responseCase = .invitation
        try PersistanceService.shared.deleteAll(Where<FDInvitation>(true))
    }

    override func tearDownWithError() throws {}

    func testLoadObjectSuccess() async throws {
        var local = try await model.fetchLocalObject()
        XCTAssertNil(local)
        XCTAssertNil(model.publisher)
        XCTAssertNil(model.snapshot)
        
        try await model.loadObject()
        XCTAssertNotNil(model.publisher)
        XCTAssertNotNil(model.snapshot)
        
        local = try await model.fetchLocalObject()
        XCTAssertNotNil(local)
    }
    
    func testLoadObjectFailed() async throws {
        MockNetworkActor.responseCase = .error
        var local = try await model.fetchLocalObject()
        XCTAssertNil(local)
        XCTAssertNil(model.publisher)
        XCTAssertNil(model.snapshot)
        
        do {
            try await model.loadObject()
        } catch {
            XCTAssertNotNil(error)
        }
        XCTAssertNil(model.publisher)
        XCTAssertNil(model.snapshot)
        
        local = try await model.fetchLocalObject()
        XCTAssertNil(local)
    }
    
    func testFetchLocalObject() async throws {
        //import local object
        MockNetworkActor.responseCase = .invitation
        let _ = try await FDInvitation.fetchRemoteObject(id: objectID)
        MockNetworkActor.responseCase = .error
        let local = try await model.fetchLocalObject()
        
        //fetch local success but failed at remote
        XCTAssertNotNil(local)
        XCTAssertNil(model.publisher)
        do {
            try await model.loadObject()
        } catch {
            XCTAssertNotNil(error)
        }
        XCTAssertNotNil(model.publisher)
    }

}
