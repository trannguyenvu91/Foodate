//
//  Date.swift
//  JustDate
//
//  Created by Vu Tran on 7/14/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation

extension DateFormatter {
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

extension Date {
    
    var timeText: String {
        DateFormatter.time.string(from: self)
    }
    
    var monthText: String {
        DateFormatter.month.string(from: self)
    }
    
    var dayText: String {
        isToday ? "Hôm nay" : DateFormatter.weekday.string(from: self)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    func shift(day: Int, at hour: Int, minute: Int) -> Date {
        let current = Calendar.current.dateComponents(in: .current, from: self)
        let result = DateComponents(calendar: .current,
                                    year: current.year,
                                    month: current.month,
                                    day: current.day! + 1,
                                    hour: hour,
                                    minute: minute)
        return Calendar.current.date(from: result)!
    }
    
    func ageFromBirth() -> Int {
        let calendar = Calendar(identifier: .iso8601)
        return calendar.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
}


