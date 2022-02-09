//
//  AppDelegate.swift
//  Foodate
//
//  Created by Vu Tran on 12/29/21.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject {}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationService.shared = NotificationService(center: UNUserNotificationCenter.current(), application: application)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        NotificationService.shared.didReceive(token: token, error: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NotificationService.shared.didReceive(token: nil, error: error)
    }
    
}

