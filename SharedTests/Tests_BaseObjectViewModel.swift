//
//  Tests_BaseObjectViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 1/17/22.
//

import XCTest
import CoreStore
import Combine

class Tests_BaseObjectViewModel: BaseTestCase {
    
    lazy var model = BaseObjectViewModel<FDInvitation>(invitationID)
    var invitationJSON: JSON {
        try! MockResponse.invitation.jsonValue
    }
    var invitationID: Int {
        invitationJSON["id"] as! Int
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        try LibraryAPI.shared.deleteAll(FDInvitation.self)
    }
    
    func testExistedLocalWithErrorNetwork() async throws {
        MockNetworkActor.responseCase = .error
        try LibraryAPI.shared.saveUniqueObject(FDInvitation.self, from: invitationJSON)
        do {
            try await model.loadObject()
            XCTAssertNotNil(model.publisher)
        } catch {
            XCTAssert(error is NetworkError)
        }
    }
    
    func testEmptyLocalWithErrorNetwork() async throws {
        MockNetworkActor.responseCase = .error
        try LibraryAPI.shared.deleteAll(FDInvitation.self)
        do {
            try await model.loadObject()
            XCTAssertNil(model.publisher)
        } catch {
            XCTAssert(error is NetworkError)
        }
    }
    
    func testEmptyLocalWithSuccessNetwork() async throws {
        MockNetworkActor.responseCase = .invitation
        try LibraryAPI.shared.deleteAll(FDInvitation.self)
        try await model.loadObject()
        XCTAssertNotNil(model.publisher)
    }
    
    func testExistedLocalWithSuccessNetwork() async throws {
        MockNetworkActor.responseCase = .invitation
        try LibraryAPI.shared.saveUniqueObject(FDInvitation.self, from: invitationJSON)
        try await model.loadObject()
        XCTAssertNotNil(model.publisher)
    }
    
}
