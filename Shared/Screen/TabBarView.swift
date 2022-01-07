//
//  TabBarView.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 28/07/2021.
//

import SwiftUI
import CoreStore

struct TabBarView: View {
    
    let tabFontSize: CGFloat = 22
    @State var selectedTabItem: TabItemType = .calendar
    @EnvironmentObject var config: AppConfig
    
    var body: some View {
        TabView(selection: $selectedTabItem) {
            calendarView.tabItem {
                Image(systemName: "calendar")
                    .resizable()
                    .font(.system(size: tabFontSize))
            }
            .tag(TabItemType.calendar)
            sugguestView.tabItem {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .font(.system(size: tabFontSize))
            }
            .tag(TabItemType.suggest)
            notificationView.tabItem {
                Image(systemName: "bell.badge.fill")
                    .resizable()
                    .font(.system(size: tabFontSize))
            }
            .tag(TabItemType.notifications)
            profileView.tabItem {
                Image(systemName: "person.circle")
                    .resizable()
                    .font(.system(size: tabFontSize))
            }
            .tag(TabItemType.profile)
        }
        .tabViewStyle(.automatic)
        .task {
            try? await AppConfig.shared.updateUserLocation()
            try? await AppConfig.shared.updateNotificationsToken()
        }
    }
    
    @ViewBuilder
    var profileView: some View {
        if let id = AppConfig.shared.sessionUser?.$id,
           let user = try? FDUserProfile.fetchOne(id: id) {
            let publiser = user.asPublisher(in: .defaultStack)
            NavigationView {
                UserProfileView(model: .init(publiser))
            }
        }
    }
    
    var sugguestView: some View {
        NavigationView {
            SearchView(model: .init())
        }
    }
    
    @ViewBuilder
    var calendarView: some View {
        if config.sessionUser != nil {
            NavigationView {
                CalendarView()
            }
        }
    }
    
    var notificationView: some View {
        NavigationView {
            NotificationView()
        }
    }
    
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
