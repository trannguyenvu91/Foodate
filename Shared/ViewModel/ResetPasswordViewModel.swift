//
//  ResetPasswordViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import Foundation
import Combine

class ResetPasswordViewModel: BaseViewModel {
    
    @Published var password = ""
    @Published var username = ""
    
    @MainActor
    func resetPassword() async throws {
        let _ = try await LibraryAPI.shared.reset(username: username, password: password)
        try? LibraryAPI.shared.resetSessionUser()
        AppFlow.shared.refresh.toggle()
    }
    
}
