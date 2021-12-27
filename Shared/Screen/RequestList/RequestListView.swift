//
//  RequestListView.swift
//  Foodate
//
//  Created by Vu Tran on 03/08/2021.
//

import SwiftUI

struct RequestListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model: RequestListViewModel
    
    init(_ invitationID: Int) {
        self.model = RequestListViewModel(invitationID)
    }
    
    var body: some View {
        List {
            EmptyView()
//            PaginationList(model.paginator) {
//                RequesterCell($0.asSnapshot(in: .defaultStack)!, model: model)
//                    .asAnyView()
//            }
        }
        .navigationBarTitle("Lời yêu cầu")
        .bindErrorAlert(to: $model)
        .onReceive(model.viewDismissalModePublisher) { dismiss in
            if dismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .refreshable {
            await model.refresh()
        }
    }
}

struct RequestListView_Previews: PreviewProvider {
    static var previews: some View {
        RequestListView(2)
    }
}
