//
//  Tests_OnboardingViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 1/17/22.
//

import XCTest

class Tests_OnboardingViewModel: BaseTestCase {
    
    let model = OnboardingViewModel()

    override func setUpWithError() throws {
        try super.setUpWithError()
        try LibraryAPI.shared.logOut()
        locationManager.authorizationStatus = .authorizedWhenInUse
        locationManager._updatingLocationResult = .success(.init())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSwitchType() throws {
        let expectation = XCTestExpectation()
        model.objectWillChange.sink { _ in
            expectation.fulfill()
        }.store(in: &cancelableSet)
        let mode = model.mode
        model.switchType()
        XCTAssertNotEqual(mode, model.mode)
        wait(for: [expectation], timeout: 1)
    }
    
    func testAuthenticateUserSuccess() async throws {
        XCTAssertNil(LibraryAPI.shared.userSnapshot)
        MockNetworkActor.responseCase = .sessionUser
        try await model.authenticateUser()
        XCTAssertNotNil(LibraryAPI.shared.userSnapshot)
    }
    
    func testAuthenticateUserFailed() async throws {
        XCTAssertNil(LibraryAPI.shared.userSnapshot)
        MockNetworkActor.responseCase = .error
        try? await model.authenticateUser()
        XCTAssertNil(LibraryAPI.shared.userSnapshot)
    }

}
