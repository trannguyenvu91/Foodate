//
//  InvitationView.swift
//  Foodate
//
//  Created by Vu Tran on 12/22/21.
//

import SwiftUI
import CoreStore

struct InvitationView: View {
    
    @ObservedObject var model: InvitationViewModel
    
    var body: some View {
        List {
            if let publisher = model.invitation {
                InvitationCell(publisher)
            }
            if model.canViewRequests {
                PaginationList(model.paginator) {
                    RequesterCell(requester: $0.asSnapshot(in: .defaultStack)!, model: model)
                        .asAnyView()
                }
            }
        }
        .listStyle(.plain)
        .bindErrorAlert(to: $model)
        .onLoad {
            model.asyncDo { try await model.getInvitation() }
        }
        .refreshable {
            await model.refresh()
        }
        .navigationTitle("InvitationView_Title".localized())
    }
}

struct InvitationView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationView(model: InvitationViewModel(0))
    }
}
