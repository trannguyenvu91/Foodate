//
//  Tests_NotificationSocketMonitor.swift
//  Foodate
//
//  Created by Vu Tran on 2/26/22.
//

import XCTest

class Tests_NotificationSocketMonitor: BaseTestCase {

    let task = MockSocketTask()
    lazy var monitor = NotificationSocketMonitor(task)

    func testReceive() throws {
        let json = try MockResponse.notification.jsonValue
        let data = try JSONSerialization.data(withJSONObject: ["notification": json], options: .fragmentsAllowed)
        let expect = XCTestExpectation()
        monitor.observe { noti in
            XCTAssertEqual(noti.asSnapshot(in: .defaultStack)?.$id, json["id"] as? Int)
            expect.fulfill()
        }
        task.receiveMessageHandler?(.success(.data(data)))
        wait(for: [expect], timeout: 2)
    }

}
