//
//  String+Localized.swift
//  Foodate
//
//  Created by Vu Tran on 09/10/2021.
//

import Foundation
import UIKit

extension String {
    
    public func localized() -> String {
        let language = UserDefaults.standard.string(forKey: UserDefaultsKey.language) ?? "en"
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return (bundle?.localizedString(forKey: self, value: nil, table: nil))!
    }

    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized(), arguments: arguments)
    }

}
