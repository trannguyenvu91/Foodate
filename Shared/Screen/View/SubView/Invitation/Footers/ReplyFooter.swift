//
//  ReplyFooter.swift
//  ReplyFooter
//
//  Created by Vu Tran on 25/07/2021.
//

import SwiftUI

struct ReplyFooter: View {
    
    @ObservedObject var model: InvitationCellModel
    
    init(_ model: InvitationCellModel) {
        self.model = model
    }
    
    var body: some View {
        HStack(spacing: 10) {
            AsyncButton(task: {
                try await model.reply(.matched)
            }, error: $model.error) {
                Text("ReplyFooter_Accept_Button_Title".localized())
                    .font(.footnote)
                    .fontWeight(.medium)
            }
            .tint(.blue)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            AsyncButton(task: {
                try await model.reply(.rejected)
            }, error: $model.error) {
                Text("ReplyFooter_Reject_Button_Title".localized())
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .tint(.groupTableViewBackground)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
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
