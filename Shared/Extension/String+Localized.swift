//
//  String+Localized.swift
//  Foodate
//
//  Created by Vu Tran on 09/10/2021.
//

import Foundation

extension String {

    public func localized() -> String {
        let path = Bundle.main.path(forResource: "vi", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return (bundle?.localizedString(forKey: self, value: nil, table: nil))!
    }

    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized(), arguments: arguments)
    }

}
