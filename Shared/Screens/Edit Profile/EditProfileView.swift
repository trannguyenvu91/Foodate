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
                    inputView(TextField("Enter first name", text: $model.draft.firstName), title: "First Name")
                    inputView(TextField("Enter last name", text: $model.draft.lastName), title: "Last Name")
                    inputView(TextField("Enter user name", text: $model.draft.userName), title: "User Name")
                    inputView(TextField("Enter email", text: $model.draft.email), title: "Email")
                    inputView(TextField("Enter bio", text: $model.draft.bio), title: "Bio")
                    inputView(TextField("Enter job", text: $model.draft.job), title: "Job")
                }
            }
            .navigationBarTitle(model.session.name,displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: updateButton)
        }
        .onReceive(model.didUpdateProfile) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
        .bindErrorAlert(to: $model)
    }
    
    var updateButton: some View {
        Button(action: {
            self.model.updateCommand.send(nil)
        }) {
            Text("Update")
                .bold()
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            self.model.didUpdateProfile.send(true)
        }) {
            Text("Cancel")
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
    
    func inputView(_ field: TextField<Text>, title: String, withDivider: Bool = true) -> some View {
        return HStack(alignment: .top, spacing: 16) {
            HStack {
                Text(title)
                Spacer(minLength: 0)
            }
            .width(90)
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
