//
//  InvitationCell.swift
//  Foodate
//
//  Created by Vu Tran on 22/07/2021.
//

import SwiftUI
import CoreStore

struct InvitationCell: View {
    
    @StateObject var model: InvitationCellModel
    var showPlace = true
    var showRequestsFooter = true
    
    var body: some View {
        ObjectReader(model.objectPublisher) { snapshot in
            VStack(spacing: 0) {
                TimeHeader(snapshot)
                contentView(snapshot)
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: .gray, radius: 3, x: 0, y: 1)
            .padding(.bottom, 12)
            .plainedButton()
        }
        .bindErrorAlert(to: $model)
    }
    
    func contentView(_ snapshot: ObjectSnapshot<FDInvitation>) -> some View {
        VStack(alignment: .leading) {
            if let owner = snapshot.$owner?.asSnapshot(in: .defaultStack) {
                UserHeader(owner)
                    .height(40)
            }
            Text(snapshot.$title ?? "")
            if let place = snapshot.$place, showPlace {
                PlaceHeader(place)
            }
            footer(snapshot)
                .height(50)
        }
        .padding(12)
        .background(Color.white.cornerRadius(30))
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    func footer(_ snapshot: ObjectSnapshot<FDInvitation>) -> some View {
        switch snapshot.action {
        case .viewRequests:
            if showRequestsFooter {
                RequestsFooter(snapshot.$requests,
                                      requestsTotal: snapshot.$requestsTotal ?? 0,
                                      invitationID: snapshot.$id)
            }
        case .request:
            SendRequestFooter(snapshot.isRequested, model: model)
        case .reply:
            ReplyFooter(model)
        case .viewReply(let toUser):
            ReplyStateView(toUser, state: snapshot.$state ?? .pending)
        case .invite:
            InviteFooter(model.inviteFriend)
        }
    }
    
}

struct InvitationCell_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        InvitationCell(model: .init(invitation))
    }
}
