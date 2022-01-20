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
            return "InvitationState_Pending".localized()
        case .matched:
            return "InvitationState_Matched".localized()
        case .archived:
            return "InvitationState_Archived".localized()
        case .canceled:
            return "InvitationState_Canceled".localized()
        case .rejected:
            return "InvitationState_Rejected".localized()
        }
    }
}
