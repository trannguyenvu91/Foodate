//
//  NotificationService.swift
//  Foodate
//
//  Created by Vu Tran on 12/29/21.
//

import Foundation
import UserNotifications
import UIKit

protocol UserNotificationCenterProtocol {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func notificationSettings() async -> UNNotificationSettings
    var delegate: UNUserNotificationCenterDelegate? { get set }
}

protocol ApplicationProtocol {
    func registerForRemoteNotifications()
    var delegate: UIApplicationDelegate? { get set }
}

extension UNUserNotificationCenter: UserNotificationCenterProtocol {}
extension UIApplication: ApplicationProtocol {}

class NotificationService: NSObject {
    
    static var shared: NotificationService = NotificationService()
    lazy var center: UserNotificationCenterProtocol = UNUserNotificationCenter.current()
    lazy var application: ApplicationProtocol = UIApplication.shared
    
    private var token: String? = nil
    private var registerCallback: ((String?, Error?) -> Void)?
    
    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.badge, .sound, .alert])
    }
    
    func getAuthorizationStatus() async -> UNAuthorizationStatus {
        await center.notificationSettings().authorizationStatus
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
        //TODO:
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
