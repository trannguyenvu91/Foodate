//
//  NotificationPermissionView.swift
//  Foodate
//
//  Created by Vu Tran on 12/29/21.
//

import SwiftUI

struct NotificationPermissionView: View {
    @State var error: Error? {
        willSet {
            isPresentingError = newValue != nil
        }
    }
    @State var isPresentingError = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Image("notification-permission")
                .resizable()
                .scaledToFit()
                .width(300)
            Text("NotificationPermissionView_Title".localized())
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(.cyan)
            Text("NotificationPermissionView_SubTitle".localized())
                .font(.title2)
                .padding([.leading, .trailing], 30)
                .multilineTextAlignment(.center)
                .padding(.top, 2)
                .foregroundColor(.gray)
            AsyncButton(task: {
                try await AppSession.shared.updateNotificationsToken()
                presentationMode.wrappedValue.dismiss()
            }, error: $error) {
                Text("NotificationPermissionView_AllowButton".localized())
                    .fontWeight(.semibold)
                    .padding([.leading, .trailing], 50)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.blue)
            .controlSize(.large)
            .padding(.top, 40)
            .foregroundColor(.white)
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("NotificationPermissionView_SkipButton".localized())
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.top, 4)
        }
        .presentAlert(error: error, isPresented: $isPresentingError)
    }
}

struct NotificationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPermissionView()
    }
}
