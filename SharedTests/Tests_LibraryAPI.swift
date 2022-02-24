//
//  Tests_LibraryAPI.swift
//  Foodate
//
//  Created by Vu Tran on 1/17/22.
//

import XCTest
import CoreStore

class Tests_LibraryAPI: BaseTestCase {
    
    lazy var sessionJson: JSON = {
        try! Bundle(for: type(of: self))
            .json(forResource: "session_user", ofType: "json")
    }()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        try persistance.deleteAll(FDSessionUser.self)
        let _ = try FDSessionUser.importObject(from: sessionJson)
        try LibraryAPI.shared.resetSessionUser()
    }

    func testLogOut() throws {
        try LibraryAPI.shared.logOut()
        let sessionUser = try persistance.fetchOne(FDSessionUser.self)
        try LibraryAPI.shared.resetSessionUser()
        XCTAssertNil(sessionUser)
        XCTAssertNil(LibraryAPI.shared.userSnapshot)
    }

}
