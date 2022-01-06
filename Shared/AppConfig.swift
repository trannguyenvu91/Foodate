//
//  AppConfig.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import Combine
import CoreStore
import SwiftUI

class AppConfig: ObservableObject {
    
    static let shared = AppConfig()
    @Published var isPresentingScreen: Bool = false
    @Published var isPushingScreen: Bool = false
    @Published var presentScreen: ScreenType? {
        didSet {
            isPresentingScreen = presentScreen != nil
        }
    }
    @Published var pushedScreen: ScreenType? {
        didSet {
            isPushingScreen = pushedScreen != nil
        }
    }
    @Published var sessionUser: ObjectSnapshot<FDSessionUser>? {
        willSet {
            NetworkConfig.token = newValue?.$token
        }
    }
    
    init() {
        setup()
    }
    
    func setup() {
        FDCoreStore.shared.setup()
        sessionUser = try? FDCoreStore.shared.fetchSessionUser()
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    func updateUserLocation() async throws {
        let location = try await LocationService.shared.requestLocation()
        try await sessionUser?.update(location: location)
    }
    
    func updateNotificationsToken() async throws {
        let status = try await NotificationService.shared.getAuthorizationStatus()
        guard status != .notDetermined else {
            presentScreen = .notificationPermission
            return
        }
        guard status != .denied else {
            throw(NotificationError.notAvailable)
        }
        let token = try await NotificationService.shared.registerNotifications()
        try await sessionUser?.update(notificationToken: token)
    }
    
    func logOut() {
        withAnimation {
            sessionUser = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let _ = try? FDCoreStore.shared.dataStack.perform { transaction in
                try? transaction.deleteAll(From<FDSessionUser>())
            }
        }
    }

    
}
