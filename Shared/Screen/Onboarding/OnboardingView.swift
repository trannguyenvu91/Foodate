//
//  OnboardingView.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import SwiftUI

struct OnboardingView: View {
    
    @ObservedObject var model = OnboardingViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                Spacer(minLength: 40)
                Image("pizza-coffee")
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width, alignment: .center)
                Text("OnboardingView_Title".localized())
                    .font(.largeTitle)
                    .padding([.top, .bottom], 30)
                    .foregroundColor(.gray)
                if self.model.isSignup {
                    IconInputView(
                        Image(systemName: "envelope"),
                        build: TextField("Email", text: self.$model.email)
                    )
                }
                IconInputView(
                    Image(systemName: "person"),
                    build: TextField("Username", text: self.$model.username)
                )
                IconInputView(
                    Image(systemName: "lock"), build: SecureField("Password", text: self.$model.password)
                )
                HStack {
                    Spacer()
                    forgotPasswordButton
                        .padding(.trailing, 30)
                }
                Button(action: {
                    self.model.authenticateUser()
                }) {
                    Text(self.model.mode.title)
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .controlSize(.large)
                .buttonBorderShape(.capsule)
                .padding(.top, 20)
                Spacer()
            }
        }
        .resignKeyboardOnDragGesture()
        .overlay(switchView, alignment: .bottom)
        .bindErrorAlert(to: $model)
        .animation(.easeInOut, value: 1)
    }
    
    var switchView: some View {
        HStack {
            Text(model.mode.switchLabel)
            Button(action: {
                self.model.switchType()
            }) {
                Text(self.model.mode.switchButton)
                    .font(.headline)
            }
        }
        .padding(.bottom, 20)
    }
    
    var forgotPasswordButton: some View {
        Group {
            switch model.mode {
            case .login:
                PresentButton(destination: LazyView(ResetPasswordView())) {
                    Text("Forgot password?")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            default:
                EmptyView()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
