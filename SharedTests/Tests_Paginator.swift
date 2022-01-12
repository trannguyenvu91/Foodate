//
//  Tests_Paginator.swift
//  Foodate
//
//  Created by Vu Tran on 1/12/22.
//

import XCTest

class Tests_Paginator: BaseTestCase {
    
    lazy var firstPage: NetworkPage<FDNotification> = PreviewResource.shared
        .loadObject(source: "notification_page",
                    type: "json",
                    in: .init(for: type(of: self)))
    lazy var paginator = Paginator<FDNotification>(firstPage)
    
    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    func testInitialization() throws {
        XCTAssertEqual(firstPage.results, paginator.items)
        XCTAssertFalse(paginator.isFetching)
        XCTAssertNil(paginator.error)
        XCTAssertTrue(paginator.hasNext)
    }
    
    func testFetchNextSuccess() async throws {
        let expect = XCTestExpectation()
        paginator.objectWillChange.sink {
            expect.fulfill()
        }
        .store(in: &cancelableSet)
        MockNetworkService.responseCase = .notificationPage
        try await paginator.fetchNext()
        XCTAssertFalse(paginator.isFetching)
        XCTAssertNil(paginator.error)
        XCTAssertGreaterThan(paginator.items.count, firstPage.results?.count ?? 0)
        wait(for: [expect], timeout: 5)
    }
    
    func testFetchNextFailure() async throws {
        MockNetworkService.responseCase = .error
        let expect = XCTestExpectation()
        paginator.objectWillChange.sink {
            expect.fulfill()
        }
        .store(in: &cancelableSet)
        do {
            try await paginator.fetchNext()
        } catch {
            XCTAssertNotNil(error)
        }
        XCTAssertFalse(paginator.isFetching)
        XCTAssertNotNil(paginator.error)
        XCTAssertEqual(paginator.items, firstPage.results)
        wait(for: [expect], timeout: 5)
    }
    
    func testRefreshSuccess() async throws {
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
