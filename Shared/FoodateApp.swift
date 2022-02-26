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
    
    @StateObject var flow = AppFlow.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            mainView
                .environmentObject(flow)
                .sheet(isPresented: $flow.isPresentingScreen) {
                    if let view = flow.presentScreen?.view {
                        view
                    } else {
                        EmptyView()
                    }
                }
                .overlay(alignment: .top) {
                    if let noti = flow.presentingNotification?.asPublisher(in: .defaultStack) {
                        NotificationBanner(notification: noti)
                    } else {
                        EmptyView()
                    }
                }
        }
    }
    
    var mainView: some View {
        Group {
            if !LibraryAPI.shared.isLocationPermissionGranted {
                LocationPermissionView()
            } else if let id = LibraryAPI.shared.userSnapshot?.$id,
                      let user = try? LibraryAPI.shared.fetchOne(FDUserProfile.self, id: id),
                      let _ = user.asPublisher(in: .defaultStack) {
                TabBarView()
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut, value: 1)
    }
    
}
