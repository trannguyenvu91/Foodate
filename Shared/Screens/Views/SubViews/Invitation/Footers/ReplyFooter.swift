//
//  ReplyFooter.swift
//  ReplyFooter
//
//  Created by Vu Tran on 25/07/2021.
//

import SwiftUI

struct ReplyFooter: View {
    
    var model: InvitationCellModel
    
    init(_ model: InvitationCellModel) {
        self.model = model
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                model.reply.send(.matched)
            } label: {
                Text("Đồng ý")
                    .paddingForBorderBackground()
                    .foregroundColor(.white)
                    .background(Color.blue)
            }
            .buttonRounded()
            Button {
                model.reply.send(.rejected)
            } label: {
                Text("Từ chối")
                    .paddingForBorderBackground()
                    .background(Color.groupTableViewBackground)
                    .buttonRounded()
            }
        }
    }
}

struct ReplyFooter_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        let model = InvitationCellModel(invitation)
        ReplyFooter(model).height(40)
    }
}
