//
//  MockSocketTask.swift
//  Foodate
//
//  Created by Vu Tran on 2/26/22.
//

import Foundation

class MockSocketTask: NSObject, SocketTask {
    var isRunning: Bool = false
    
    weak var delegate: URLSessionTaskDelegate?
    
    func resume() {
        isRunning = true
    }
    
    func send(_ message: URLSessionWebSocketTask.Message) async throws {
        if let error = sendMessageError {
            throw error
        }
    }
    
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isRunning = false
    }
    
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        receiveMessageHandler = completionHandler
    }
    
    func sendPing(pongReceiveHandler: @escaping (Error?) -> Void) {
        pongReceiveHandler(pingReceiveError)
    }
    
    var pingReceiveError: Error?
    var sendMessageError: Error?
    var receiveMessageHandler: ((Result<URLSessionWebSocketTask.Message, Error>) -> Void)?
}
