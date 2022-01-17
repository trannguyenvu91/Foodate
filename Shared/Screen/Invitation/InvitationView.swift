//
//  InvitationView.swift
//  Foodate
//
//  Created by Vu Tran on 12/22/21.
//

import SwiftUI
import CoreStore

struct InvitationView: View {
    
    @StateObject var model: InvitationViewModel
    
    var body: some View {
        List {
            if model.isArchivedInvitation {
                ArchivedInvitationHeader()
            }
            if let publisher = model.publisher {
                InvitationCell(model: .init(publisher), showRequestsFooter: false)
            }
            if model.canViewRequests {
                PaginationList(model.paginator, placeholderBuilder: { EmptyView() }) {
                    RequesterCell(requester: $0.asSnapshot(in: .defaultStack)!, model: model)
                }
                .disabled(model.isArchivedInvitation)
            }
        }
        .listStyle(.plain)
        .taskOnLoad(error: $model.error) {
            try await model.loadObject()
        }
        .refreshable {
            await model.refresh()
        }
        .bindErrorAlert(to: $model)
        .navigationTitle("InvitationView_Title".localized())
    }
}

struct InvitationView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationView(model: InvitationViewModel(0))
    }
}
