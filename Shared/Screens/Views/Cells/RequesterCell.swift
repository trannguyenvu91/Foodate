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
    var model: RequestListViewModel
    
    init(_ requester: ObjectSnapshot<FDRequester>, model: RequestListViewModel) {
        self.requester = requester
        self.model = model
    }
    
    var body: some View {
        HStack {
            UserHeader(requester)
            Spacer()
            Button {
                model.acceptRequester.send(requester)
            } label: {
                Text("Đồng ý")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .paddingForBorderBackground()
                    .foregroundColor(.white)
                    .background(Color.blue)
            }
            .buttonRounded(4)
        }
        .plainedButton()
    }
}

struct RequesterCell_Previews: PreviewProvider {
    static var previews: some View {
        RequesterCell(PreviewResource.shared.loadRequester().asSnapshot(in: .defaultStack)!,
                      model: RequestListViewModel(2))
    }
}
