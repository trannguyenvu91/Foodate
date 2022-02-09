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
                    ofType: "json")
    lazy var paginator = Paginator<FDNotification>(firstPage)
    
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
        MockNetworkActor.responseCase = .notificationPage
        try await paginator.fetchNext()
        XCTAssertFalse(paginator.isFetching)
        XCTAssertNil(paginator.error)
        XCTAssertGreaterThan(paginator.items.count, firstPage.results?.count ?? 0)
        wait(for: [expect], timeout: 5)
    }
    
    func testFetchNextFailure() async throws {
        MockNetworkActor.responseCase = .error
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
        MockNetworkActor.responseCase = .notificationPage
        let expect = XCTestExpectation()
        paginator.objectWillChange.sink {
            expect.fulfill()
        }
        .store(in: &cancelableSet)
        try await paginator.refresh()
        XCTAssertFalse(paginator.isFetching)
        XCTAssertNil(paginator.error)
        wait(for: [expect], timeout: 5)
    }
    
    func testRemove() {
        guard let (first, last) = (paginator.items.first, paginator.items.last) as? (FDNotification, FDNotification) else {
            return
        }
        paginator.remove(item: first)
        XCTAssertFalse(paginator.items.contains(first))
        paginator.remove(item: last)
        XCTAssertFalse(paginator.items.contains(last))
    }

}
