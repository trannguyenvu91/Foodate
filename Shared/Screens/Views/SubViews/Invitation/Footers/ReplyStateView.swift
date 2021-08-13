//
//  ReplyStateView.swift
//  ReplyStateView
//
//  Created by Vu Tran on 25/07/2021.
//

import SwiftUI
import CoreStore

struct ReplyStateView: View {
    var toUser: ObjectSnapshot<FDUser>
    var state: FDInvitationState
    
    init(_ toUser: ObjectSnapshot<FDUser>, state: FDInvitationState) {
        self.toUser = toUser
        self.state = state
    }
    var body: some View {
        HStack(spacing: 0) {
            Image("sent-icon")
                .resizable()
                .scaledToFit()
                .height(20)
            UserHeader(toUser)
                .height(30)
                .padding(.trailing, 0)
            HStack {
                Text(String.dotText)
                    .fontWeight(.medium)
                Text(state.description)
                    .fontWeight(.medium)
                Spacer()
            }
            .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct ReplyStateView_Previews: PreviewProvider {
    static var previews: some View {
        let user: ObjectPublisher<FDUser> = PreviewResource.shared
            .loadUser()
        ReplyStateView(user.asSnapshot(in: .defaultStack)!, state: .pending)
    }
}
