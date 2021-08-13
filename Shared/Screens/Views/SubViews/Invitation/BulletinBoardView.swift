//
//  BulletinBoardView.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 22/07/2021.
//

import SwiftUI
import CoreStore

struct BulletinBoardView: View {
    
    var invitations: [ObjectPublisher<FDInvitation>]
    var showPlace = true
    
    init(_ invitations: [ObjectPublisher<FDInvitation>], showPlace: Bool = true) {
        self.invitations = invitations
        self.showPlace = showPlace
    }
    var body: some View {
        ForEach(invitations, id: \.self) { invitation in
            InvitationCell(invitation, showPlace: showPlace)
        }
    }
}

struct BulletinBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BulletinBoardView([])
    }
}
