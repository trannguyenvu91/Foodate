//
//  UserDefaults+Key.swift
//  Foodate
//
//  Created by Vu Tran on 1/24/22.
//

import Foundation

typealias UserDefaultsKey = String

extension UserDefaultsKey {
    static var language: Self {
        "language"
    }
    
    static var skipNotificationSetting: Self {
        "skipNotificationSetting"
    }
}
