//
//  NotificationService.swift
//  Foodate
//
//  Created by Vu Tran on 12/29/21.
//

import Foundation
import UserNotifications
import Combine
import UIKit

protocol NotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func notificationSettings() async -> UNNotificationSettings
    var delegate: UNUserNotificationCenterDelegate? { get set }
}

protocol Application {
    func registerForRemoteNotifications()
    var delegate: UIApplicationDelegate? { get set }
}

extension UNUserNotificationCenter: NotificationCenter {}
extension UIApplication: Application {}

extension NotificationCenter where Self == UNUserNotificationCenter {
    static var current: Self {
        UNUserNotificationCenter.current()
    }
}

class NotificationService: NSObject {
    
    static var shared: NotificationService!
    private(set) var center: NotificationCenter
    private(set) var application: Application
    private var token: String? = nil
    private var registerCallback: ((String?, Error?) -> Void)?
    
    init(center: NotificationCenter, application: Application) {
        self.center = center
        self.application = application
        super.init()
        self.center.delegate = self
    }
    
    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.badge, .sound, .alert])
    }
    
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        await notificationSettings.authorizationStatus
    }
    
    var notificationSettings: UNNotificationSettings {
        get async {
            await center.notificationSettings()
        }
    }
    
    func registerNotifications() async throws -> String {
        guard try await requestAuthorization() else {
            throw(NotificationError.notGranted)
        }
        return try await withCheckedThrowingContinuation { continuation in
            registerCallback = { [unowned self] token, error in
                if let token = token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: error ?? NotificationError.notAvailable)
                }
                registerCallback = nil
            }
            DispatchQueue.main.async {
                self.application.registerForRemoteNotifications()
            }
        }
    }
    
    func didReceive(token: String?, error: Error?) {
        registerCallback?(token, error)
    }
    
    @MainActor
    func didReceive(notification: UNNotification) async {
        //TODO: Popup banner for in app noti
        AppSession.shared.pushedScreen = .invitation(71)
    }
    
}

extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .sound, .banner, .list]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        await NotificationService.shared.didReceive(notification: response.notification)
    }
    
}
