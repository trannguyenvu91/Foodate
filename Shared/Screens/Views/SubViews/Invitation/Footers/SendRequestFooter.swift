//
//  SendRequestFooter.swift
//  SendRequestFooter
//
//  Created by Vu Tran on 25/07/2021.
//

import SwiftUI

struct SendRequestFooter: View {
    
    var requestSent: Bool = false
    var model: InvitationCellModel
    
    init(_ requestSent: Bool, model: InvitationCellModel) {
        self.requestSent = requestSent
        self.model = model
    }
    
    var body: some View {
        Button {
            self.model.sendRequest.send(!requestSent)
        } label: {
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
        .paddingForBorderBackground()
        .foregroundColor(requestSent ? .white : .black)
        .background(requestSent ? Color.blue : .groupTableViewBackground)
        .buttonRounded()
    }
    
}

struct SendRequestFooter_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        let model = InvitationCellModel(invitation)
        SendRequestFooter(false, model: model).height(50)
    }
}
