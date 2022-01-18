//
//  OnboardingViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Combine
import CoreStore
import Foundation

class OnboardingViewModel: BaseViewModel {
    @Published var mode: OnboardingMode = .login
    @Published var email = ""
    @Published var password = "123456"
    @Published var username = "vutran"
    
    var isSignup: Bool {
        mode == .signUp
    }
    
    func authenticateUser() async throws {
        switch mode {
        case .login:
            let _ = try await NetworkService.login(username: username, password: password)
        case .signUp:
            let _ = try await NetworkService.register(username: username,
                                                      password: password,
                                                      email: email)
        }
        try await AppSession.shared.updateUserLocation()
        try AppSession.shared.loadSessionUser()
    }
    
    func switchType() {
        mode = isSignup ? .login : .signUp
    }
}
