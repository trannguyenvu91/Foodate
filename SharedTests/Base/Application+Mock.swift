//
//  UIApplication+Mock.swift
//  Foodate
//
//  Created by Vu Tran on 1/13/22.
//

import UIKit

enum NotificationRegisterResult {
    case success(String)
    case error(Error)
}

class MockApplication: Application {
    
    var delegate: UIApplicationDelegate?
    var _notificationRegisterResult: NotificationRegisterResult = .error(NotificationError.notAvailable)
    
    func registerForRemoteNotifications() {
        switch _notificationRegisterResult {
        case .success(let token):
            delegate?.application?(.shared,
                                   didRegisterForRemoteNotificationsWithDeviceToken: try! token.hexadecimal)
        case .error(let error):
            delegate?.application?(.shared,
                                   didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
    
}
