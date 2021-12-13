//
//  CalendarType.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import Foundation

enum CalendarType: String, CaseIterable {
    case events = "events"
    case inbox = "inbox"
    
    var title: String {
        switch self {
        case .events:
            return "CalendarType_Events_Title".localized()
        case .inbox:
            return "CalendarType_Inbox_Title".localized()
        }
    }
}
