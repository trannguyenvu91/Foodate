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
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LibraryAPI.shared = LibraryAPI(application)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        NotificationCenter.default.post(name: .didReceiveNotificationToken,
                                        object: nil,
                                        userInfo: ["token": token])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NotificationCenter.default.post(name: .didReceiveNotificationToken,
                                        object: nil,
                                        userInfo: ["error": error])
    }
    
}

