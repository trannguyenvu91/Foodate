//
//  Tests_SearchablePaginator.swift
//  Foodate
//
//  Created by Vu Tran on 1/18/22.
//

import XCTest
import CoreStore
import Foundation

class Tests_SearchablePaginator: BaseTestCase {
    
    lazy var initialPage: NetworkPage<FDNotification> = PreviewResource.shared.loadObject(source: "notification_page", ofType: "json")
    lazy var searchPage: NetworkPage<FDNotification> = PreviewResource.shared.loadObject(source: "notification_page_shorten", ofType: "json")
    lazy var searchPage2: NetworkPage<FDNotification> = PreviewResource.shared.loadObject(source: "notification_page_shorten_2", ofType: "json")
    lazy var paginator = SearchablePaginator(initialPage)

    override func setUpWithError() throws {
        try super.setUpWithError()
        MockNetworkActor.responseCase = .notificationPageShorten
    }

    override func tearDownWithError() throws {}

    @MainActor
    func testSearch() async throws {
        try await paginator.search(["name": "a"])
        XCTAssertEqual(paginator.items.asSnapshots().map(\.$id), searchPage.results?.asSnapshots().map(\.$id))
        XCTAssertEqual(paginator.placeholderPage?.results?.asSnapshots().map(\.$id), initialPage.results?.asSnapshots().map(\.$id))
        XCTAssertEqual(paginator.filter?["name"] as? String, "a")
        XCTAssertFalse(paginator.isFetching)
        XCTAssertFalse(paginator.isRefreshing)
        //search 2
        MockNetworkActor.responseCase = .notificationPageShorten2
        try await paginator.search(["name": "b"])
        XCTAssertEqual(paginator.items.asSnapshots().map(\.$id), searchPage2.results?.asSnapshots().map(\.$id))
        XCTAssertEqual(paginator.placeholderPage?.results?.asSnapshots().map(\.$id), initialPage.results?.asSnapshots().map(\.$id))
        XCTAssertEqual(paginator.filter?["name"] as? String, "b")
        XCTAssertFalse(paginator.isFetching)
        XCTAssertFalse(paginator.isRefreshing)
        //clear search
        paginator.clearSearch()
        XCTAssertNil(paginator.filter?["name"])
        XCTAssertEqual(paginator.items.asSnapshots().map(\.$id), initialPage.results?.asSnapshots().map(\.$id))
        XCTAssertFalse(paginator.isFetching)
        XCTAssertFalse(paginator.isRefreshing)
    }

}
