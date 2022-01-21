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
    @AppStorage("language") var language: String = "en"
    @State var showLanguageSheet = false
    @ObjectState var sessionUser: ObjectSnapshot<FDSessionUser>?
    
    init() {
        self._sessionUser = .init(AppSession.shared.sessionUser?.asPublisher(in: .defaultStack))
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
            Section {
                Button {
                    try? AppSession.shared.logOut()
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
            CircleView(ASRemoteImageView(path: AppSession.shared.sessionUser?.$avatarURL),
                       lineWidth: 4)
                .frame(width: 100, height: 100)
                .shadow(radius: 8)
                .onAppear {
                    ASRemoteImageManager.shared.load(path: AppSession.shared.sessionUser?.$avatarURL)
                }
            Spacer()
        }
    }
    
    var profileCell: some View {
        PresentButton(destination: LazyView(EditProfileView(model: .init(model.userProfile)))) {
            HStack {
                Text("SettingView_Edit_Profile".localized())
                Spacer()
                Text(AppSession.shared.sessionUser?.name ?? "Anonymous")
                    .foregroundColor(.gray)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
    
    var languageCell: some View {
        HStack {
            Text("SettingView_Navigation_Language".localized())
            Spacer()
            Text(language)
                .foregroundColor(.gray)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .onTapGesture {
            showLanguageSheet.toggle()
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
