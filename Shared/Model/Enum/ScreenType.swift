//
//  ScreenEnum.swift
//  Foodate
//
//  Created by Vu Tran on 12/30/21.
//

import Foundation
import SwiftUI

enum ScreenType {
    case notificationPermission
    case invitation(Int)
    
    var view: some View {
        Group {
            switch self {
            case .notificationPermission:
                NotificationPermissionView()
            case .invitation(let invitationID):
                InvitationView(model: .init(invitationID))
            }
        }
    }
    
    
}
