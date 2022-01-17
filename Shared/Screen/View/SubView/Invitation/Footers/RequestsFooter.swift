//
//  RequestsFooter.swift
//  Foodate
//
//  Created by Vu Tran on 23/07/2021.
//

import SwiftUI
import CoreStore

struct RequestsFooter: View {
    
    var requests: [ObjectPublisher<FDRequester>]
    var requestsTotal: Int
    let maxPreview = 2
    var invitationID: Int
    
    init(_ requests: [ObjectPublisher<FDRequester>], requestsTotal: Int, invitationID: Int) {
        self.requests = requests
        self.requestsTotal = requestsTotal
        self.invitationID = invitationID
    }
    
    var body: some View {
        NavigationButton(destination: LazyView(InvitationView(model: .init(invitationID))),
                      content: {
            HStack {
                GroupPhotosView(avatarURLs)
                    .height(30)
                nameView
                Image(systemName: "arrowtriangle.forward.fill")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .height(10)
                    .foregroundColor(.gray)
            }
        })
    }
    
    var avatarURLs: [String] {
        requests.compactMap({ $0.asSnapshot(in: .defaultStack)?.$avatarURL })
    }
    
    var nameView: some View {
        let names = requests.compactMap({ $0.asSnapshot(in: .defaultStack)?.name })
            .prefix(maxPreview)
        let others = names.count == requestsTotal ? "" : " và \(requestsTotal - names.count) người khác"
        return HStack(spacing: 4) {
            Text(names.joined(separator: ", "))
                .fontWeight(.semibold)
            Text(others + " đã gửi yêu cầu")
                .fontWeight(.medium)
                .foregroundColor(.gray)
        }
    }
    
}

struct RequestsFooter_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        let snapshot = invitation.asSnapshot(in: .defaultStack)!
        let requests = snapshot.$requests
        RequestsFooter(requests, requestsTotal: snapshot.$requestsTotal ?? 0, invitationID: 2)
            .height(40)
    }
}
