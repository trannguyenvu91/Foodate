//
//  NotificationType.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import Foundation
import SwiftUI

enum NotificationType: String {
    case newEvent = "NEW_EVENT"
    case newRequest = "NEW_REQUEST"
    case newInvitation = "NEW_INVITATION"
    case canceledInvitation = "CANCELED_INVITATION"
    case rejectedInvitation = "REJECTED_INVITATION"
    case updatedInvitation = "UPDATED_INVITATION"
}

extension NotificationType {
    var detail: (String, String, Color) {
        switch self {
        case .newRequest:
            return ("NotificationType_NewRequest_Title".localized(), "plus.circle.fill", .sentRequest)
        case .newInvitation:
            return ("NotificationType_NewInvitation_Title".localized(), "arrowshape.turn.up.forward.circle.fill", .directInvitation)
        case .newEvent:
            return ("NotificationType_NewEvent_Title".localized(), "person.2.circle.fill", .matched)
        case .rejectedInvitation:
            return ("NotificationType_RejectedInvitation_Title".localized(), "minus.circle.fill", .rejected)
        case .canceledInvitation:
            return ("NotificationType_CanceledInvitation_Title".localized(), "multiply.circle.fill", .canceled)
        case .updatedInvitation:
            return ("NotificationType_UpdatedInvitation_Title".localized(), "shuffle.circle.fill", .blue)
        }
    }
}
