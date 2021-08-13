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
                Text("Welcome to Food8")
                    .font(.largeTitle)
                    .padding([.top, .bottom], 30)
                    .foregroundColor(.gray)
                if self.model.isSignup {
                    self.inputView(icon: Image(systemName: "envelope"), textField: TextField("Email address", text: self.$model.email))
                }
                self.inputView(icon: Image(systemName: "person"), textField: TextField("Username", text: self.$model.username))
                self.inputView(icon: Image(systemName: "lock"), textField: TextField("Password", text: self.$model.password))
                Button(action: {
                    self.model.authenticateUser()
                }) {
                    Text(self.model.mode.title)
                        .font(.headline)
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .resignKeyboardOnDragGesture()
        .overlay(switchView, alignment: .bottom)
        .bindErrorAlert(to: $model)
    }
    
    func inputView(icon: Image, textField: TextField<Text>) -> some View {
        HStack {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.blue)
            textField
        }
        .padding(8)
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(Color.lightGray, lineWidth: 1))
        .padding([.leading, .trailing], 30)
        .padding(.bottom, 8)
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
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
