//
//  Date.swift
//  JustDate
//
//  Created by Vu Tran on 7/14/20.
//  Copyright © 2020 Vu Tran. All rights reserved.
//

import Foundation

extension TimeInterval {
    var hourString: String {
        let hours: Int = Int(self / 3600)
        let mininutes: Int = Int((self - Double(hours) * 3600) / 60)
        var str = mininutes != 0 ? "\(mininutes)m": ""
        if hours != 0 {
            str = "\(hours)h" + str
        }
        return str
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


