//
//  InvitationAction.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import Foundation
import CoreStore

enum InvitationAction {
    case viewReply(ObjectSnapshot<FDUser>)
    case viewRequests
    case invite
    case request
    case reply
}
