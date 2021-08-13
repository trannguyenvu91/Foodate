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
        List(model.requesters, id: \.self) { requester in
            RequesterCell(requester, model: model)
        }
        .navigationBarTitle("Lời yêu cầu")
        .bindErrorAlert(to: $model)
        .onReceive(model.viewDismissalModePublisher) { dismiss in
            if dismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct RequestListView_Previews: PreviewProvider {
    static var previews: some View {
        RequestListView(2)
    }
}
