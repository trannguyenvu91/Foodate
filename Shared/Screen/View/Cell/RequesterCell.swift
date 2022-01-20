//
//  RequesterCell.swift
//  Foodate
//
//  Created by Vu Tran on 03/08/2021.
//

import SwiftUI
import CoreStore

struct RequesterCell: View {
    
    var requester: ObjectSnapshot<FDRequester>
    @ObservedObject var model: InvitationViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            UserHeader(requester)
                .height(35)
            Spacer()
            AsyncButton(task: {
                try await model.accept(requester)
            }, error: $model.error) {
                Text("RequesterCell_Accept_Button_Title".localized())
                    .font(.footnote)
                    .fontWeight(.medium)
            }
            .tint(.blue)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.regular)
        }
        .padding([.top, .bottom], 6)
    }
}

struct RequesterCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = InvitationViewModel(0)
        return RequesterCell(requester: PreviewResource.shared.loadRequester().asSnapshot(in: .defaultStack)!, model: model)
    }
}
