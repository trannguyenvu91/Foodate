//
//  FoodateApp.swift
//  Shared
//
//  Created by Vu Tran on 13/07/2021.
//

import SwiftUI
import CoreStore

@main
struct FoodateApp: App {
    
    @ObservedObject var config = AppConfig.shared
    
    init() {
        config.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            if !LocationService.shared.manager.isPermissionGranted {
                LocationView()
            } else if let id = config.sessionUser?.$id,
               let user = try? FDUserProfile.fetchOne(id: id),
               let _ = user.asPublisher(in: .defaultStack) {
                TabBarView()
            } else {
                OnboardingView()
            }
        }
    }
}
