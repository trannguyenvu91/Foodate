//
//  OnboardingMode.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import Foundation

enum OnboardingMode {
    case signUp
    case login
    
    var title: String {
        switch self {
        case .login:
            return "OnboardingView_Login_Title".localized()
        case .signUp:
            return "OnboardingView_SignUp_Title".localized()
        }
    }
    
    var switchLabel: String {
        switch self {
        case .login:
            return "OnboardingView_Login_Switch_Label".localized()
        case .signUp:
            return "OnboardingView_SignUp_Switch_Label".localized()
        }
    }
    
    var switchButton: String {
        switch self {
        case .login:
            return "OnboardingView_Login_Switch_Button".localized()
        case .signUp:
            return "OnboardingView_SignUp_Switch_Button".localized()
        }
    }
    
}
