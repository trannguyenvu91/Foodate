//
//  ResetPasswordView.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @StateObject var model = ResetPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text("ResetPasswordView_Title".localized())
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.top, 100)
                VStack(alignment: .leading) {
                    IconInputView(
                        Image(systemName: "person"),
                        build: TextField("Username", text: $model.username)
                    )
                        .padding(.top)
                    IconInputView(
                        Image(systemName: "lock"),
                        build: SecureField("ResetPasswordView_NewPassword".localized(), text: $model.password)
                    )
                    Spacer()
                }
                .padding(20)
                .frame(height: proxy.size.height)
                .background(Color.white)
                .cornerRadius(18)
            }
            .background(Color.orange)
            .fixedSize(horizontal: false, vertical: true)
        }
        .navigationTitle("ResetPasswordView_ResetPassword".localized())
        .overlay(alignment: .bottom) {
            resetButton
        }
        .overlay(alignment: .topLeading) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .padding(20)
            }
            .tint(.white)
        }
        .bindErrorAlert(to: $model)
        
    }
    
    var resetButton: some View {
        AsyncButton(task: {
            try await model.resetPassword()
        }, error: $model.error) {
            HStack {
                Image(systemName: "arrow.clockwise.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                Text("ResetPasswordView_ResetPassword".localized())
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
        .tint(.orange)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .buttonStyle(.borderedProminent)

    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
