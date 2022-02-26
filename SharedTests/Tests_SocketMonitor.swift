//
//  Tests_SocketMonitor.swift
//  Foodate
//
//  Created by Vu Tran on 2/25/22.
//

import XCTest

class Tests_SocketMonitor: BaseTestCase {

    let socketTask = MockSocketTask()
    lazy var monitor = SocketMonitor(socketTask)

    func testInitialization() throws {
        let _ = monitor
        XCTAssertNotNil(socketTask.delegate)
    }
    
    func testPing() async throws {
        socketTask.pingReceiveError = nil
        let success = try await monitor.ping()
        XCTAssertTrue(success)
        socketTask.pingReceiveError = NetworkError.invalidJSONFormat
        do {
            try await monitor.ping()
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testSend() async throws {
        socketTask.sendMessageError = nil
        try await monitor.send(.string("Hello, world!"))
        
        do {
            socketTask.sendMessageError = NetworkError.invalidJSONFormat
            try await monitor.send(.string("should failed"))
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testStop() {
        monitor.stop()
        XCTAssertFalse(socketTask.isRunning)
    }
    
    func testStartWithStringMesasage() {
        let expect = XCTestExpectation()
        let messages = (0..<20).map({ _ in UUID().uuidString })
        var recievedMessages = [String]()
        
        monitor.start { result in
            switch result {
            case let .success(message):
                guard case .string(let str) = message else { return }
                recievedMessages.append(str)
                if messages == recievedMessages {
                    expect.fulfill()
                }
            default:
                XCTFail("Should only receive string")
            }
        }
        XCTAssertTrue(socketTask.isRunning)
        messages.forEach { str in
            socketTask.receiveMessageHandler?(.success(.string(str)))
        }
        wait(for: [expect], timeout: 2)
    }

}
