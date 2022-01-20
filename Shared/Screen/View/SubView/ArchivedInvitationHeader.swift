//
//  ArchivedInvitationHeader.swift
//  Foodate
//
//  Created by Vu Tran on 1/6/22.
//

import SwiftUI

struct ArchivedInvitationHeader: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("ArchivedInvitationHeader_Title".localized())
                    .font(.body)
                Text("ArchivedInvitationHeader_SubTitle".localized())
                    .font(.footnote)
            }
            .foregroundColor(.gray)
            PresentButton(destination: LazyView(InviteView(model: .init()))) {
                Text("Copy")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding([.leading, .trailing])
            .padding([.top, .bottom], 8)
            .background(Color.blue.clipShape(.stadium))
        }
    }
}

struct ArchivedInvitationHeader_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedInvitationHeader()
    }
}
