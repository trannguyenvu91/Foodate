//
//  UserProfileView.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 15/07/2021.
//

import SwiftUI
import CoreStore

struct UserProfileView: View {
    
    @StateObject var model: UserProfileViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ObjectReader(model.publisher) { snapshot in
                List {
                    PhotosPageView(snapshot.$photos)
                        .listRowInsets(EdgeInsets())
                        .frame(width: proxy.size.width, height: proxy.size.width)
                    personalInfoView(snapshot)
                    PaginationList(model.paginator) {
                        InviteCell(model.publisher)
                    } cellBuilder: {
                        InvitationCell(model: .init($0.asPublisher(in: .defaultStack)))
                    }
                }
                .navigationTitle(snapshot.name)
            }
        }
        .taskOnLoad(error: $model.error) {
            try await model.loadObject()
        }
        .refreshable {
            await model.refresh()
        }
        .bindErrorAlert(to: $model)
        .ignoresSafeArea()
        .listStyle(.plain)
        .navigationBarItems(trailing: model.publisher?.isSession == true ? logOutButton.asAnyView() : EmptyView().asAnyView())
    }
    
    func personalInfoView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(snapshot.name)
                    .font(.title)
                    .fontWeight(.medium)
                Text("\(snapshot.age ?? 0)" + "UserProfileView_Age_Suffix".localized())
                    .font(.title)
            }
            workView(snapshot)
            livingView(snapshot)
            Text(snapshot.$bio ?? "--")
            inviteView(snapshot)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func workView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> some View {
        HStack {
            Image(systemName: "briefcase")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(maxWidth: 20, maxHeight: 20)
            Text(snapshot.$job ?? "--")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
    
    func livingView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .scaledToFit()
                .foregroundColor(.orange)
                .frame(maxWidth: 20, maxHeight: 20)
            Text(snapshot.$location?.distanceFromCurrent ?? "--")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
    }
    
    func inviteView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> some View {
        let recipient = snapshot.isSession ? nil : snapshot
        let buttonTitle = snapshot.isSession ? "UserProfileView_Creat_Button_Title".localized() : "Invite_Button_Title".localized() + " " + (snapshot.$firstName ?? "")
        return PresentButton(destination: LazyView(InviteView(model: .init(recipient)))) {
            HStack {
                Image(systemName: "calendar.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30, maxHeight: 30)
                Text(buttonTitle)
                    .fontWeight(.medium)
            }
            .foregroundColor(.orange)
        }
    }
    
    var logOutButton: some View {
        NavigationButton(destination: LazyView(SettingView())) {
            Image(systemName: "gear")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 30, maxHeight: 30)
                .foregroundColor(.blue)
        }
    }
    
    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user: ObjectPublisher<FDUserProfile> = PreviewResource.shared
            .loadUser()
        UserProfileView(model: .init(user.id!))
    }
}
