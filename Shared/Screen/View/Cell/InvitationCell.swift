//
//  InvitationCell.swift
//  Foodate
//
//  Created by Vu Tran on 22/07/2021.
//

import SwiftUI
import CoreStore

struct InvitationCell: View {
    
    @ObservedObject var model: InvitationCellModel
    var showPlace = true
    var showRequestsFooter = true
    
    
    init(_ invitation: ObjectPublisher<FDInvitation>,
         showPlace: Bool = true,
         showRequestsFooter: Bool = true) {
        self.model = InvitationCellModel(invitation)
        self.showPlace = showPlace
        self.showRequestsFooter = showRequestsFooter
    }
    
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
            UserHeader(snapshot.$owner!.asSnapshot(in: .defaultStack)!)
                .height(40)
            Text(snapshot.$title ?? "")
            if showPlace {
                PlaceHeader(snapshot.$place!)
            }
            footer(snapshot)
                .height(50)
        }
        .padding(12)
        .background(Color.white.cornerRadius(30))
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func footer(_ snapshot: ObjectSnapshot<FDInvitation>) -> AnyView {
        switch snapshot.action {
        case .viewRequests:
            guard showRequestsFooter else {
                return EmptyView()
                    .asAnyView()
            }
            return RequestsFooter(snapshot.$requests,
                                  requestsTotal: snapshot.$requestsTotal ?? 0,
                                  invitationID: snapshot.$id)
                .asAnyView()
        case .request:
            return SendRequestFooter(snapshot.isRequested, model: model)
                .asAnyView()
        case .reply:
            return ReplyFooter(model)
                .asAnyView()
        case .viewReply(let toUser):
            return ReplyStateView(toUser, state: snapshot.$state ?? .pending)
                .asAnyView()
        case .invite:
            return InviteFooter(model.inviteFriend)
                .asAnyView()
        }
    }
    
}

struct InvitationCell_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        InvitationCell(invitation)
    }
}
