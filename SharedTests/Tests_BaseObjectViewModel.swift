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
        MockNetworkActor.responseCase = .invitation
        try LibraryAPI.shared.deleteAll(FDInvitation.self)
    }
    
    func testExistedLocalWithErrorNetwork() async throws {
        MockNetworkActor.responseCase = .error
        try LibraryAPI.shared.saveUniqueObject(FDInvitation.self, from: invitationJSON)
        let expect = XCTestExpectation()
        do {
            try await LibraryAPI.shared.getInvitation(ID: invitationID,
                                                      success: { publisher in
                publisher != nil ? expect.fulfill() : ()
            })
        } catch {
            XCTAssert(error is NetworkError)
        }
        wait(for: [expect], timeout: 2)
    }
    
    func testEmptyLocalWithErrorNetwork() async throws {
        MockNetworkActor.responseCase = .error
        try LibraryAPI.shared.deleteAll(FDInvitation.self)
        let expect = XCTestExpectation()
        do {
            try await LibraryAPI.shared.getInvitation(ID: invitationID,
                                                      success: { publisher in
                publisher == nil ? expect.fulfill() : ()
            })
        } catch {
            XCTAssert(error is NetworkError)
        }
        wait(for: [expect], timeout: 2)
    }
    
    func testEmptyLocalWithSuccessNetwork() async throws {
        MockNetworkActor.responseCase = .invitation
        try LibraryAPI.shared.deleteAll(FDInvitation.self)
        
        let expect = XCTestExpectation()
        try await LibraryAPI.shared.getInvitation(ID: invitationID,
                                                  success: { publisher in
            publisher != nil ? expect.fulfill() : ()
        })
        wait(for: [expect], timeout: 2)
    }
    
    func testExistedLocalWithSuccessNetwork() async throws {
        MockNetworkActor.responseCase = .invitation
        try LibraryAPI.shared.saveUniqueObject(FDInvitation.self, from: invitationJSON)
        
        let expect = XCTestExpectation()
        try await LibraryAPI.shared.getInvitation(ID: invitationID,
                                                  success: { publisher in
            publisher != nil ? expect.fulfill() : ()
        })
        wait(for: [expect], timeout: 2)
    }
    
}
