//
//  NotificationService.swift
//  Foodate
//
//  Created by Vu Tran on 12/29/21.
//

import Foundation
import UserNotifications
import UIKit

class NotificationService: NSObject {
    static let shared = NotificationService()
    var token: String? = nil
    private var registerCallback: ((String?, Error?) -> Void)?
    
    func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert])
    }
    
    func getAuthorizationStatus() async throws -> UNAuthorizationStatus {
        try await withCheckedThrowingContinuation({ continuation in
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                continuation.resume(returning: settings.authorizationStatus)
            })
        })
    }
    
    func registerNotifications() async throws -> String {
        guard try await requestAuthorization() else {
            throw(NotificationError.notAvailable)
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
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func didReceive(token: String?, error: Error?) {
        registerCallback?(token, error)
    }
    
    @MainActor
    func didReceive(notification: UNNotification) async {
        //TODO:
        AppConfig.shared.pushedScreen = .invitation(71)
    }
    
}
