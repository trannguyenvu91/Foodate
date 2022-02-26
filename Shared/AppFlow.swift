//
//  AppFlow.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import Combine
import CoreStore
import SwiftUI
import CoreLocation

class AppFlow: ObservableObject {
    
    static let shared = AppFlow()

    @AppStorage(UserDefaultsKey.skipNotificationSetting) var skipNotificationSetting = false
    @Published var isPresentingScreen: Bool = false
    @Published var isPushingScreen: Bool = false
    @Published var refresh: Bool = false
    var presentingNotification: FDNotification? {
        didSet {
            refresh.toggle()
        }
    }
    
    var presentScreen: ScreenType? {
        didSet {
            isPresentingScreen = presentScreen != nil
        }
    }
    var pushedScreen: ScreenType? {
        didSet {
            isPushingScreen = pushedScreen != nil
        }
    }
    
    @MainActor
    func updateNotificationsToken() async throws {
        guard skipNotificationSetting == false else {
            return
        }
        let status = await LibraryAPI.shared.notificationAuthorizationStatus
        guard status != .notDetermined else {
            presentScreen = .notificationPermission
            return
        }
        guard status != .denied else {
            throw(NotificationError.notAvailable)
        }
        try await LibraryAPI.shared.updateNotificationToken()
    }
    
}
