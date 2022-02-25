//
//  SocketMonitor.swift
//  Foodate
//
//  Created by Vu Tran on 2/10/22.
//

import Foundation
import Combine

extension URLSession {
    static var socket: URLSession {
        URLSession(configuration: .default)
    }
}

protocol SocketTask: NSObjectProtocol {
    var delegate: URLSessionTaskDelegate? { get set }
    func resume()
    func send(_ message: URLSessionWebSocketTask.Message) async throws
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?)
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void)
    func sendPing(pongReceiveHandler: @escaping (Error?) -> Void)
    var isRunning: Bool { get }
}

extension URLSessionWebSocketTask: SocketTask {
    var isRunning: Bool {
        state == .running
    }
}

class SocketMonitor: NSObject {
    
    typealias SocketMessageResult = Result<URLSessionWebSocketTask.Message, Error>
    
    private let task: SocketTask
    var listener: SuccessCallback<SocketMessageResult>?
    
    init(_ task: SocketTask) {
        self.task = task
        super.init()
        self.task.delegate = self
        receive()
    }
    
    var isRunning: Bool {
        task.isRunning
    }
    
    func start(listening: @escaping SuccessCallback<SocketMessageResult>) {
        listener = listening
        task.resume()
    }
    
    func send(_ message: URLSessionWebSocketTask.Message) async throws {
        try await task.send(message)
    }
    
    func stop() {
        task.cancel(with: .goingAway, reason: nil)
    }
    
    @discardableResult
    func ping() async throws -> Bool {
        try await withUnsafeThrowingContinuation { continuation in
            task.sendPing { error in
                guard let error = error else {
                    continuation.resume(with: .success(true))
                    return
                }
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    private func receive() {
        task.receive { [weak self] result in
            self?.listener?(result)
        }
    }
    
    deinit {
        stop()
    }
    
}

extension SocketMonitor: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol aProtocol: String?) {
        print("Open protocol: \(aProtocol ?? "--")")
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Close websocket code: \(closeCode)")
    }
}
