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
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
    static var time: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi")
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi")
        formatter.dateFormat = "d MMM"
        return formatter
    }
    
    static var weekday: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi")
        formatter.dateFormat = "EEEE"
        return formatter
    }
    
}
