//
//  UserProfileView.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 15/07/2021.
//

import SwiftUI
import CoreStore

struct UserProfileView: View {
    
    @ObservedObject var model: UserProfileViewModel
    @State var presentSheet = false
    @State var pushEditProfile = false
    
    init(_ publisher: ObjectPublisher<FDUserProfile>) {
        model = UserProfileViewModel(publisher)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ObjectReader(model.objectPublisher) { snapshot in
                List {
                    PhotosPageView(snapshot.$photos)
                        .listRowInsets(EdgeInsets())
                        .frame(width: proxy.size.width, height: proxy.size.width)
                    personalInfoView(snapshot)
                    PaginationList(model.paginator) {
                        InviteCell(model.objectPublisher)
                            .asAnyView()
                    } cellBuilder: {
                        InvitationCell($0.asPublisher(in: .defaultStack))
                            .asAnyView()
                    }
                }
                .navigationTitle(snapshot.name)
            }
        }
        .onLoad {
            model.asyncDo {
                try await model.getProfile()
            }
        }
        .refreshable {
            await model.refresh()
        }
        .bindErrorAlert(to: $model)
        .ignoresSafeArea()
        .listStyle(PlainListStyle())
        .navigationBarItems(trailing: model.objectPublisher.isSession ? logOutButton.asAnyView() : EmptyView().asAnyView())
    }
    
    func personalInfoView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> AnyView {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(snapshot.name)
                    .font(.title)
                    .fontWeight(.medium)
                Text("\(snapshot.age ?? 0)t")
                    .font(.title)
            }
            workView(snapshot)
            livingView(snapshot)
            Text(snapshot.$bio ?? "--")
            if snapshot.isSession {
                editView
            } else {
                inviteView(snapshot)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .asAnyView()
    }
    
    func workView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> AnyView {
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
        .asAnyView()
    }
    
    func livingView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> AnyView {
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
        .asAnyView()
    }
    
    func inviteView(_ snapshot: ObjectSnapshot<FDUserProfile>) -> AnyView {
        PresentButton(destination: LazyView(InviteView(model.objectPublisher, to: nil))) {
            HStack {
                Image(systemName: "calendar.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30, maxHeight: 30)
                Text("Invite_Button_Title".localized() + " " + (snapshot.$firstName ?? ""))
                    .fontWeight(.medium)
            }
            .foregroundColor(.orange)
        }
        .asAnyView()
    }
    
    var editView: some View {
        let session = model.objectPublisher.asSnapshot(in: .defaultStack)
        return PresentButton(destination: LazyView(EditProfileView(session!))) {
            HStack {
                Image(systemName: "gear")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20, maxHeight: 20)
                Text("UserProfileView_Edit_Profile_Button_Title".localized())
                    .fontWeight(.medium)
            }
            .foregroundColor(.orange)
        }
    }
    
    var logOutButton: some View {
        Button {
            AppConfig.shared.logOut()
        } label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 30, maxHeight: 30)
                .rotationEffect(Angle(degrees: 90))
        }

    }
    
    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user: ObjectPublisher<FDUserProfile> = PreviewResource.shared
            .loadUser()
        UserProfileView(user)
    }
}
