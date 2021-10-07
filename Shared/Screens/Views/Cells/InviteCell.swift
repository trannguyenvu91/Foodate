//
//  InviteCell.swift
//  Foodate
//
//  Created by Vu Tran on 07/10/2021.
//

import SwiftUI
import CoreStore

struct InviteCell: View {
    
    var person: ObjectSnapshot<FDUserProfile>?
    var place: ObjectSnapshot<FDPlace>?
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
    }
    
}

extension InviteCell {
    
    init(_ person: ObjectPublisher<FDUserProfile>? = nil, to place: ObjectPublisher<FDPlace>? = nil) {
        self.init()
        self.person = person?.asSnapshot(in: .defaultStack)
        self.place = place?.asSnapshot(in: .defaultStack)
    }
    
    init(_ person: ObjectSnapshot<FDUserProfile>? = nil, to place: ObjectSnapshot<FDPlace>? = nil) {
        self.init()
        self.person = person
        self.place = place
    }
    
}

struct InviteCell_Previews: PreviewProvider {
    static var previews: some View {
        InviteCell()
    }
}
