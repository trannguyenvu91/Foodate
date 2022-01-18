//
//  AppSession.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import Combine
import CoreStore
import SwiftUI

class AppSession: ObservableObject {
    
    static let shared = AppSession()
    @Published var isPresentingScreen: Bool = false
    @Published var isPushingScreen: Bool = false
    var newInvitation = PassthroughSubject<FDInvitation, Never>()
    
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
    @Published private var _sessionUserpublisher: ObjectPublisher<FDSessionUser>? {
        didSet {
            NetworkConfig.token = sessionUser?.$token
        }
    }
    
    init() {
        setup()
    }

    var sessionUser: ObjectSnapshot<FDSessionUser>? {
        _sessionUserpublisher?.asSnapshot(in: .defaultStack)
    }

    func setup() {
        try? FDCoreStore.shared.setup()
        try? loadSessionUser()
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    func loadSessionUser() throws {
        _sessionUserpublisher = try FDCoreStore.shared.fetchSessionUser()
    }
    
    @MainActor
    func updateUserLocation() async throws {
        let location = try await LocationService.shared.requestLocation()
        try await sessionUser?.update(location: location)
        objectWillChange.send()
    }
    
    @MainActor
    func updateNotificationsToken() async throws {
        let status = await NotificationService.shared.getAuthorizationStatus()
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
    
    func logOut() throws {
        withAnimation {
            _sessionUserpublisher = nil
        }
        try FDCoreStore.shared.deleteAll(Where<FDSessionUser>(true))
    }

}
