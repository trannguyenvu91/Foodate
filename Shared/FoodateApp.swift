//
//  FoodateApp.swift
//  Shared
//
//  Created by Vu Tran on 13/07/2021.
//

import SwiftUI
import CoreStore
import Contacts

@main
struct FoodateApp: App {
    
    @StateObject var config = AppSession.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            mainView
                .environmentObject(config)
                .sheet(isPresented: $config.isPresentingScreen) {
                    if let view = config.presentScreen?.view {
                        view
                    } else {
                        EmptyView()
                    }
                }
        }
    }
    
    var mainView: some View {
        Group {
            if !LocationService.shared.manager.isPermissionGranted {
                LocationPermissionView()
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
