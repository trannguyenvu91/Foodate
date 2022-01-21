//
//  SettingViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 1/21/22.
//

import Foundation
import CoreStore

class SettingViewModel: BaseViewModel {
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "--"
    }
    
    var userProfile: ObjectSnapshot<FDUserProfile> {
        (try! AppSession.shared.sessionUser?.userProfile.asSnapshot(in: .defaultStack))!
    }
}
