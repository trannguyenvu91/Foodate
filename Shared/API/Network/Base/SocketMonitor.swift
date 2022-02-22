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

class SocketMonitor: NSObject {
    private(set) var path: String
    private(set) var session: URLSession
    lazy var socket: URLSessionWebSocketTask = {
        guard let url = URL(string: path) else {
            fatalError("Websocket URL must not be nil")
        }
        let task = session.webSocketTask(with: url)
        task.delegate = self
        return task
    }()
    var receivedPublisher = PassthroughSubject<JSON, Error>()
    
    init(_ session: URLSession, path: String) {
        self.path = path
        self.session = session
        super.init()
        receive()
    }
    
    func start() {
        socket.resume()
    }
    
    func send(_ message: URLSessionWebSocketTask.Message) async throws -> Bool {
        try await withUnsafeThrowingContinuation { continuation in
            socket.send(message) { error in
                guard let error = error else {
                    continuation.resume(with: .success(true))
                    return
                }
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    func stop() {
        socket.cancel(with: .goingAway, reason: nil)
    }
    
    private func receive() {
        socket.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self?.didReceive(data)
                case .string(let str):
                    let data = str.data(using: .utf8)
                    self?.didReceive(data)
                @unknown default:
                    self?.receivedPublisher.send(completion: .failure(NetworkError.invalidJSONFormat))
                }
            case .failure(let error):
                self?.receivedPublisher.send(completion: .failure(error))
            }
        }
    }
    
    private func didReceive(_ data: Data?) {
        guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data,
                                                             options: .fragmentsAllowed) as? JSON
        else {
            receivedPublisher.send(completion: .failure(NetworkError.invalidJSONFormat))
            return
        }
        receivedPublisher.send(json)
    }
    
    func ping() async throws -> Bool {
        try await withUnsafeThrowingContinuation { continuation in
            socket.sendPing { error in
                guard let error = error else {
                    continuation.resume(with: .success(true))
                    return
                }
                continuation.resume(with: .failure(error))
            }
        }
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
