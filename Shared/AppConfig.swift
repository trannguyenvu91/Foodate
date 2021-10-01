//
//  AppConfig.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import Combine
import CoreStore
import SwiftUI

class AppConfig: ObservableObject {
    
    static let shared = AppConfig()
    @Published var sessionUser: ObjectSnapshot<FDSessionUser>? {
        willSet {
            NetworkConfig.token = newValue?.$token
        }
    }
    
    func setup() {
        FDCoreStore.shared.setup()
        sessionUser = try? FDCoreStore.shared.fetchSessionUser()
        setupUI()
    }
    
    func setupUI() {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    func logOut() {
        withAnimation {
            sessionUser = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let _ = try? FDCoreStore.shared.dataStack.perform { transaction in
                try? transaction.deleteAll(From<FDSessionUser>())
            }
        }
    }

    
}
