//
//  UserNotificationCenter+Mock.swift
//  Foodate
//
//  Created by Vu Tran on 1/13/22.
//

import UIKit
import UserNotifications


extension UNNotificationSettings {
    static var fakeAuthorizationStatus: UNAuthorizationStatus = .authorized
    
    static func swizzleAuthorizationStatus() {
        let originalMethod = class_getInstanceMethod(self, #selector(getter: authorizationStatus))!
        let swizzledMethod = class_getInstanceMethod(self, #selector(getter: swizzledAuthorizationStatus))!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc var swizzledAuthorizationStatus: UNAuthorizationStatus {
        return Self.fakeAuthorizationStatus
    }
}

class MockNotificationCenter: UserNotificationCenter {
    var delegate: UNUserNotificationCenterDelegate?
    var _requestAuthorizationResult = true
    
    func requestAuthorization(options: UNAuthorizationOptions = []) async throws -> Bool {
        _requestAuthorizationResult
    }
    func notificationSettings() async -> UNNotificationSettings {
        await UNUserNotificationCenter.current().notificationSettings()
    }
    
}
