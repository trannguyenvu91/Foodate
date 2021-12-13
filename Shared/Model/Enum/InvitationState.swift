//
//  InvitationState.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import Foundation

enum InvitationState: String {
    case pending = "pending"
    case matched = "matched"
    case canceled = "canceled"
    case archived = "archived"
    case rejected = "rejected"
    
    var description: String {
        switch self {
        case .pending:
            return "Đã gửi"
        case .matched:
            return "Sẽ tham gia"
        case .archived:
            return "Đã xoá"
        case .canceled:
            return "Đã huỷ"
        case .rejected:
            return "Đã từ chối"
        }
    }
}
