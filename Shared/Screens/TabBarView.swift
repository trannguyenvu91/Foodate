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
    
    var body: some View {
        TabView {
            sugguestView.tabItem {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .font(.system(size: tabFontSize))
            }
//            scheduleView.tabItem {
//                Image(systemName: "calendar")
//                    .resizable()
//                    .font(.system(size: tabFontSize))
//            }
//            invitationView.tabItem {
//                Image(systemName: "envelope")
//                    .resizable()
//                    .font(.system(size: tabFontSize))
//            }
            profileView.tabItem {
                Image(systemName: "person.circle")
                    .resizable()
                    .font(.system(size: tabFontSize))
            }
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
    
    var profileView: AnyView {
        guard let id = AppConfig.shared.sessionUser?.$id,
           let user = try? FDUserProfile.fetchOne(id: id) else {
            return EmptyView().asAnyView()
        }
        let publiser = user.asPublisher(in: .defaultStack)
        return NavigationView {
            UserProfileView(publiser)
        }.asAnyView()
    }
    
    var sugguestView: some View {
        NavigationView {
            SearchView()
        }
    }
    
//    var scheduleView: some View {
//        NavigationView {
//            ScheduleView()
//        }
//    }
    
//    var invitationView: some View {
//        NavigationView {
//            InvitationList()
//        }
//    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
