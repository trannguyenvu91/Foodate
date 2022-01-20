//
//  InviteCell.swift
//  Foodate
//
//  Created by Vu Tran on 07/10/2021.
//

import SwiftUI
import CoreStore

struct InviteCell: View {
    
    var user: ObjectSnapshot<FDUserProfile>?
    var place: ObjectSnapshot<FDPlace>?
    
    var body: some View {
        VStack {
            Image("pizza-coffee")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(20)
            Text("Invite_Holder_Title".localized())
                .font(.title2)
            
            if let user = user {
                Text("Invite_Holder_Subtitle_People".localized(with: [user.name]))
            } else if let place = place {
                Text("Invite_Holder_Subtitle_Place".localized(with: [place.$name ?? "this place"]))
            } else {
                Text("Invite_Holder_Subtitle_Create".localized())
            }
            PresentButton(destination: LazyView(InviteView(model: .init(user, to: place)))) {
                Text("Invite_Button_Title".localized())
                    .bold()
                    .padding()
                    .foregroundColor(.blue)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .foregroundColor(.gray.opacity(0.3))
    }
}


extension InviteCell {
    
    init(_ user: ObjectPublisher<FDUserProfile>? = nil, to place: ObjectPublisher<FDPlace>? = nil) {
        self.init()
        self.user = user?.asSnapshot(in: .defaultStack)
        self.place = place?.asSnapshot(in: .defaultStack)
    }
    
    init(_ user: ObjectSnapshot<FDUserProfile>? = nil, to place: ObjectSnapshot<FDPlace>? = nil) {
        self.init()
        self.user = user
        self.place = place
    }
    
}

struct InviteCell_Previews: PreviewProvider {
    static var previews: some View {
        InviteCell()
    }
}
