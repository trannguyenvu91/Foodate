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
    
    func resetPassword() {
        asyncDo { [unowned self] in
            let _ = try await NetworkService.reset(username: username, password: password)
            AppConfig.shared.sessionUser = try? FDCoreStore.shared.fetchSessionUser()
        }
    }
    
}
