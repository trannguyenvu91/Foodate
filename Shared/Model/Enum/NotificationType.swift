//
//  NotificationType.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import Foundation

enum NotificationType: String {
    case newEvent = "NEW_EVENT"
    case newRequest = "NEW_REQUEST"
    case newInvitation = "NEW_INVITATION"
    case canceledInvitation = "CANCELED_INVITATION"
    case rejectedInvitation = "REJECTED_INVITATION"
    case updatedInvitation = "UPDATED_INVITATION"
}
