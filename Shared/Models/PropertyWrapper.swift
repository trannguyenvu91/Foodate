//
//  PropertyWrapper.swift
//  Foodate
//
//  Created by Vu Tran on 03/09/2021.
//

import Foundation

@propertyWrapper struct LinebreakRemoved {
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
}

@propertyWrapper struct Capitalized {
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.capitalized
        }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}

@propertyWrapper struct Lowercased {
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.lowercased()
        }
    }
    
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.lowercased()
    }
}
