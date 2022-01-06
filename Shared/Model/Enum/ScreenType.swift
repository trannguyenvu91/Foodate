//
//  ScreenEnum.swift
//  Foodate
//
//  Created by Vu Tran on 12/30/21.
//

import Foundation
import SwiftUI
import CoreStore

enum ScreenType {
    case notificationPermission
    case invitation(Int)
    case matched(ObjectSnapshot<FDInvitation>)
    
    var view: some View {
        Group {
            switch self {
            case .notificationPermission:
                NotificationPermissionView()
            case .invitation(let invitationID):
                InvitationView(model: .init(invitationID))
            case .matched(let invitation):
                MatchedView(invitation: invitation)
            }
        }
    }
    
}
