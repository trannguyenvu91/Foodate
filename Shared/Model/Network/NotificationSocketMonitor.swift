//
//  NotificationSocketMonitor.swift
//  Foodate
//
//  Created by Vu Tran on 2/25/22.
//

import UIKit

final class NotificationSocketMonitor: SocketMonitor {
    
    private override init(_ task: SocketTask) {
        super.init(task)
    }
    
    init(userID: Int) throws {
        guard let url = URL(string: socketBaseURL + "/ws/notifications/\(userID)/") else {
            throw NetworkError.invalidAPI(socketBaseURL + "/ws/notifications/\(userID)/")
        }
        let task = URLSession(configuration: .default)
            .webSocketTask(with: url)
        super.init(task)
    }
    
    internal override func start(listening: @escaping SuccessCallback<SocketMonitor.SocketMessageResult>) {
        super.start(listening: listening)
    }
    
    func observe(_ observing: @escaping SuccessCallback<FDNotification>) {
        start { result in
            switch result {
            case .success(let message):
                guard case .data(let data) = message,
                      let json = try? JSONSerialization.jsonObject(with: data,
                                                                   options: .allowFragments) as? JSON,
                      let notification = try? FDNotification.importUniqueObject(from: json) else {
                          return
                      }
                observing(notification)
            default:
                break
            }
        }
    }
    
}
