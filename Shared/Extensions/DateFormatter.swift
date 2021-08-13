//
//  DateFormatter.swift
//  Foodate
//
//  Created by Vu Tran on 14/07/2021.
//

import Foundation

extension DateFormatter {
    
    static let standard: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
}
