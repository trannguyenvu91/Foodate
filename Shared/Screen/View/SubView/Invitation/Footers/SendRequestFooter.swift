//
//  SendRequestFooter.swift
//  SendRequestFooter
//
//  Created by Vu Tran on 25/07/2021.
//

import SwiftUI

struct SendRequestFooter: View {
    
    var requestSent: Bool = false
    @ObservedObject var model: InvitationCellModel
    
    init(_ requestSent: Bool, model: InvitationCellModel) {
        self.requestSent = requestSent
        self.model = model
    }
    
    var body: some View {
        AsyncButton(task: {
            try await model.sendRequest(!requestSent)
        }, error: $model.error) {
            HStack(spacing: 10) {
                Image(systemName: requestSent ? "arrowshape.turn.up.right.fill" : "person.badge.plus")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .height(16)
                Text(requestSent ? "Huỷ yêu cầu" : "Tham gia")
                    .font(.footnote)
                    .fontWeight(.medium)
            }
        }
        .foregroundColor(requestSent ? .white : .orange)
        .tint(requestSent ? Color.blue : Color.orange.opacity(0.2))
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
    }
    
}

struct SendRequestFooter_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        let model = InvitationCellModel(invitation)
        SendRequestFooter(false, model: model).height(50)
    }
}
