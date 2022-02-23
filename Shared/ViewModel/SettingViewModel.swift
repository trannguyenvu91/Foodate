//
//  SettingViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 1/21/22.
//

import Foundation
import CoreStore
import UserNotifications
import SwiftUI

class SettingViewModel: BaseViewModel {
    var notificationSettings: UNNotificationSettings?
    @AppStorage(UserDefaultsKey.skipNotificationSetting) var skipNotificationSetting = false
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "--"
    }
    
    var userProfile: ObjectSnapshot<FDUserProfile> {
        (try! LibraryAPI.shared.userSnapshot?.userProfile.asSnapshot(in: .defaultStack))!
    }
    
    override func initialSetup() {
        super.initialSetup()
        loadNotificationSetting()
    }
    
    func loadNotificationSetting() {
        Task {
            notificationSettings = await LibraryAPI.shared.notificationSettings
            objectWillChange.send()
        }
    }
    
    var notificationStatus: String {
        if skipNotificationSetting {
            return "Allow now"
        }
        guard let notificationSettings = notificationSettings else {
            return "--"
        }
        if notificationSettings.authorizationStatus == .denied {
            return "Open Settings"
        }
        if notificationSettings.authorizationStatus == .notDetermined {
            return "Allow now"
        }
        var status = [String]()
        if notificationSettings.badgeSetting == .enabled {
            status.append("Badge")
        }
        if notificationSettings.soundSetting == .enabled {
            status.append("Sound")
        }
        if notificationSettings.alertSetting == .enabled {
            status.append("Alert")
        }
        return status.joined(separator: ", ")
    }
}
