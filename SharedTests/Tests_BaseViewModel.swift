//
//  Tests_BaseViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 1/17/22.
//

import XCTest
import Combine
import CoreData

class Tests_BaseViewModel: BaseTestCase {
    
    let model = BaseViewModel()

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testError() throws {
        XCTAssertNil(model.error)
        XCTAssertFalse(model.showErrorMessage)
        model.error = AppError.unknown
        XCTAssertTrue(model.showErrorMessage)
        model.error = nil
        XCTAssertFalse(model.showErrorMessage)
    }
    
    func testAsyncDo() {
        let expect = XCTestExpectation()
        model.asyncDo {
            throw AppError.unknown
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.model.error)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2)
    }
    
    func testBind() {
        let expect = XCTestExpectation()
        let changes = (0...10).map({ _ in BaseViewModel() })
        var changeCount = 0
        model.bind(changes.map(\.objectWillChange))
        model.objectWillChange.sink { _ in
            changeCount += 1
            if changeCount == changes.count {
                expect.fulfill()
            }
        }
        .store(in: &cancelableSet)
        for change in changes {
            change.objectWillChange.send()
        }
        wait(for: [expect], timeout: 2)
    }

}
