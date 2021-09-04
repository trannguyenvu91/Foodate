//
//  OnboardingViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Combine
import CoreStore

enum OnboardingMode {
    case signUp
    case login
    
    var title: String {
        switch self {
        case .login:
            return "LOGIN"
        case .signUp:
            return "CREATE AN ACCOUNT"
        }
    }
    
    var switchLabel: String {
        switch self {
        case .login:
            return "Don't have an account?"
        case .signUp:
            return "Already have an account?"
        }
    }
    
    var switchButton: String {
        switch self {
        case .login:
            return "Sign Up"
        case .signUp:
            return "Login"
        }
    }
    
}

class OnboardingViewModel: BaseViewModel {
    @Published var mode: OnboardingMode = .login
    @Lowercased var email = ""
    var password = "honglong"
    @Lowercased var username = "vutran"
    
    var isSignup: Bool {
        mode == .signUp
    }
    
    var authorizePublisher: NetworkPublisher<FDSessionUser> {
        switch mode {
        case .login:
            return NetworkService.login(username: username, password: password)
        case .signUp:
            return NetworkService.register(username: username,
                                           password: password,
                                           email: email)
        }
    }
    
    func authenticateUser() {
        execute(publisher: authorizePublisher) { _ in
            AppConfig.shared.sessionUser = try? FDCoreStore.shared.fetchSessionUser()
        }
    }
    
    func switchType() {
        mode = isSignup ? .login : .signUp
    }
}
