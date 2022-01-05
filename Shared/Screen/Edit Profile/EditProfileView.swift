//
//  EditProfileView.swift
//  Foodate
//
//  Created by Vu Tran on 13/08/2021.
//

import SwiftUI
import CoreStore

struct EditProfileView: View {
    
    @ObservedObject var model: EditProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(_ snapshot: ObjectSnapshot<FDUserProfile>) {
        self.model = EditProfileViewModel(snapshot)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    avatarView(proxy.size.width)
                    inputView(
                        TextField("EditProfile_Enter_first_name".localized(),
                                  text: $model.draft.firstName),
                        title: "UserProfileView_Edit_Profile_FirstName_Label".localized()
                    )
                    inputView(
                        TextField("EditProfile_Enter_last_name".localized(),
                                  text: $model.draft.lastName),
                        title: "UserProfileView_Edit_Profile_LastName_Label".localized()
                    )
                    inputView(
                        TextField("EditProfile_Enter_user_name".localized(),
                                  text: $model.draft.userName),
                        title: "Username"
                    )
                    inputView(
                        TextField("EditProfile_Enter_email".localized(),
                                  text: $model.draft.email),
                        title: "Email"
                    )
                    inputView(birthdayButton, title: "Birthday")
                    inputView(
                        TextField("EditProfile_Enter_bio".localized(),
                                  text: $model.draft.bio),
                        title: "UserProfileView_Edit_Profile_Bio_Label".localized()
                    )
                    inputView(
                        TextField("EditProfile_Enter_job".localized(),
                                  text: $model.draft.job),
                        title: "UserProfileView_Edit_Profile_Job_Label".localized()
                    )
                }
            }
            .navigationBarTitle(model.session.name,displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: updateButton)
        }
        .bindErrorAlert(to: $model)
    }
    
    var updateButton: some View {
        AsyncButton(task: {
            try await model.update()
            presentationMode.wrappedValue.dismiss()
        }, error: $model.error) {
            Text("Update_Button_Title".localized())
                .bold()
        }
    }
    
    var birthdayButton: some View {
        HStack {
            DatePicker("", selection: $model.draft.birthday, displayedComponents: [.date])
            Spacer()
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel_Button_Title".localized())
                .bold()
        }
    }
    
    func avatarView(_ width: CGFloat) -> some View {
        let imageWidth = max(150, width / 3)
        let padding = (width - imageWidth) / 2
        return CircleView(ASRemoteImageView(path: model.session.$avatarURL),
                          lineWidth: 4)
            .frame(width: imageWidth, height: imageWidth)
            .shadow(radius: 8)
            .padding([.leading, .trailing], padding)
            .padding([.top, .bottom], 16)
    }
    
    func inputView<Content: View>(_ field: Content, title: String, withDivider: Bool = true) -> some View {
        return HStack(alignment: .top, spacing: 16) {
            HStack {
                Text(title)
                Spacer(minLength: 0)
            }
            .width(80)
            .padding([.leading, .top], 12)
            VStack {
                field.padding(12)
                    .overlay(Divider().padding([.leading, .trailing], 12), alignment: .bottom)
            }
        }
    }
    
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let user: ObjectPublisher<FDUserProfile> = PreviewResource.shared.loadUser()
        EditProfileView(user.asSnapshot(in: .defaultStack)!)
    }
}
