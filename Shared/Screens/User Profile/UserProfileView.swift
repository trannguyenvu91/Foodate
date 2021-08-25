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
            ObjectReader(model.objectPubliser) { snapshot in
                List {
                    PhotosPageView(snapshot.$photos)
                        .listRowInsets(EdgeInsets())
                        .frame(width: proxy.size.width, height: proxy.size.width)
                    personalInfoView(snapshot)
                    BulletinBoardView(snapshot.$bulletinBoard)
                }
                .navigationTitle(snapshot.name)
            }
        }
        .onAppear {
            model.refreshProfile()
        }
        .bindErrorAlert(to: $model)
        .ignoresSafeArea()
        .listStyle(PlainListStyle())
        .navigationBarItems(trailing: model.objectPubliser.isSession ? logOutButton.asAnyView() : EmptyView().asAnyView())
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
        PresentButton(destination: LazyView(InviteView(person: model.objectPubliser, to: nil))) {
            HStack {
                Image(systemName: "calendar.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30, maxHeight: 30)
                Text("Mời \(snapshot.$firstName ?? "")")
                    .fontWeight(.medium)
            }
            .foregroundColor(.orange)
        }
        .asAnyView()
    }
    
    var editView: some View {
        Button(action: {
            self.pushEditProfile.toggle()
        }) {
            HStack {
                Image(systemName: "gear")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20, maxHeight: 20)
                Text("Sửa trang cá nhân")
                    .fontWeight(.medium)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.orange)
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
