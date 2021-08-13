//
//  InviteFooter.swift
//  Foodate
//
//  Created by Vu Tran on 26/07/2021.
//

import SwiftUI
import Combine

struct InviteFooter: View {
    var inviteFriend: PassthroughSubject<Any, Never>
    init(_ inviteFriend: PassthroughSubject<Any, Never>) {
        self.inviteFriend = inviteFriend
    }
    var body: some View {
        PresentButton(destination: LazyView(SearchView([.account], selectionCommand: inviteFriend))) {
            HStack {
                Image(systemName: "person.badge.plus")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .height(16)
                Text("Rủ bạn bè")
            }
        }
    }
}

struct InviteFooter_Previews: PreviewProvider {
    static var previews: some View {
        InviteFooter(PassthroughSubject<Any, Never>())
            .height(50)
    }
}
