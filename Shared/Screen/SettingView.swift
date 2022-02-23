//
//  SettingView.swift
//  Foodate
//
//  Created by Vu Tran on 1/21/22.
//

import SwiftUI
import CoreStore

struct SettingView: View {
    @StateObject var model = SettingViewModel()
    @AppStorage(UserDefaultsKey.language) var language = "en"
    @AppStorage(UserDefaultsKey.skipNotificationSetting) var skipNotificationSetting = false
    @State var showLanguageSheet = false
    @ObjectState var sessionUser: ObjectSnapshot<FDSessionUser>?
    
    init() {
        self._sessionUser = .init(LibraryAPI.shared.userSnapshot?.asPublisher(in: .defaultStack))
    }
    
    var body: some View {
        List {
            Section {
                EmptyView()
            } header: {
                avatarView
            }
            profileCell
            languageCell
            notificationCell
            Section {
                Button {
                    try? LibraryAPI.shared.logOut()
                } label: {
                    HStack {
                        Spacer()
                        Text("SettingView_Logout".localized())
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            } footer: {
                HStack {
                    Spacer()
                    VStack {
                        Text("Foodate")
                            .font(.title3)
                        Text(model.appVersion)
                    }
                    Spacer()
                }
                .padding(.top)
            }
        }
        .navigationTitle("SettingView_Navigation_Title".localized())
        .actionSheet(isPresented: $showLanguageSheet) {
            languageSheet
        }
    }
    
    var avatarView: some View {
        HStack {
            Spacer()
            CircleView(ASRemoteImageView(path: LibraryAPI.shared.userSnapshot?.$avatarURL),
                       lineWidth: 4)
                .frame(width: 100, height: 100)
                .shadow(radius: 8)
                .onAppear {
                    ASRemoteImageManager.shared.load(path: LibraryAPI.shared.userSnapshot?.$avatarURL)
                }
            Spacer()
        }
    }
    
    var profileCell: some View {
        PresentButton(destination: LazyView(EditProfileView(model: .init(model.userProfile)))) {
            cell(title: "SettingView_Edit_Profile".localized(), subtitle: LibraryAPI.shared.userSnapshot?.name ?? "Anonymous")
        }
    }
    
    var languageCell: some View {
        cell(title: "SettingView_Navigation_Language".localized(), subtitle: language)
        .onTapGesture {
            showLanguageSheet.toggle()
        }
    }
    
    var notificationCell: some View {
        return cell(title: "Notification_Tilte".localized(), subtitle: model.notificationStatus)
    }
    
    func cell(title: String, subtitle: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(subtitle)
                .foregroundColor(.gray)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
    
    var languageSheet: ActionSheet {
        ActionSheet(title: Text("SettingView_Set_Language_Title".localized()),
                    message: Text("SettingView_Set_Language_SubTitle".localized()),
                    buttons: [
                        .cancel(
                            Text("SettingView_Set_Language_Cancel".localized())
                        ),
                        .default(
                            Text("SettingView_Set_Language_Vietnamese".localized()),
                            action: {
                                language = "vi"
                            }
                        ),
                        .default(
                            Text("SettingView_Set_Language_English".localized()),
                            action: {
                                language = "en"
                            }
                        )
                    ]
        )
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
