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

protocol UserNotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func notificationSettings() async -> UNNotificationSettings
    var delegate: UNUserNotificationCenterDelegate? { get set }
}

protocol Application {
    func registerForRemoteNotifications()
    var delegate: UIApplicationDelegate? { get set }
}

extension UNUserNotificationCenter: UserNotificationCenter {}
extension UIApplication: Application {}

extension UserNotificationCenter where Self == UNUserNotificationCenter {
    static var current: Self {
        UNUserNotificationCenter.current()
    }
}

class NotificationService: NSObject {
    
    private(set) var center: UserNotificationCenter
    private(set) var application: Application
    private var token: String? = nil
    private var registerCallback: ((String?, Error?) -> Void)?
    
    init(center: UserNotificationCenter, application: Application) {
        self.center = center
        self.application = application
        super.init()
        self.center.delegate = self
        observeNotificationToken()
    }
    
    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.badge, .sound, .alert])
    }
    
    var authorizationStatus: UNAuthorizationStatus {
        get async {
            await notificationSettings.authorizationStatus
        }
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
    
    func didReceive(notification: UNNotification) async {
        //TODO: Do not use Library API here. Push notfication instead.
        await LibraryAPI.shared.didReceiveNotification(notification)
    }
    
    func observeNotificationToken() {
        NotificationCenter.default.addObserver(forName: .didReceiveNotificationToken,
                                               object: nil,
                                               queue: .main) { [weak self] noti in
            guard let userInfo = noti.userInfo else { return }
            let token = userInfo["token"] as? String
            let error = userInfo["error"] as? Error
            self?.registerCallback?(token, error)
        }
    }
    
}

extension NSNotification.Name {
    static var didReceiveNotificationToken: Self = NSNotification.Name("didReceiveNotificationToken")
}

extension NotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .sound, .banner, .list]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        await didReceive(notification: response.notification)
    }
    
}
