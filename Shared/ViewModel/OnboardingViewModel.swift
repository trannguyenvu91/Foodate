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
            let _ = try await LibraryAPI.shared.login(username: username, password: password)
        case .signUp:
            let _ = try await LibraryAPI.shared.register(username: username,
                                                      password: password,
                                                      email: email)
        }
        try await LibraryAPI.shared.updateUserLocation()
        try LibraryAPI.shared.resetSessionUser()
        //TODO: Update Appflow
    }
    
    func switchType() {
        mode = isSignup ? .login : .signUp
    }
}
