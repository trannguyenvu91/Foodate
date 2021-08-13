//
//  TimeHeader.swift
//  Foodate
//
//  Created by Vu Tran on 23/07/2021.
//

import SwiftUI
import CoreStore

struct TimeHeader: View {
    
    var startAt: Date?
    var endAt: Date?
    var privacy: InvitationPrivacy = .open
    
    
    init(start: Date?, end: Date?, privacy: InvitationPrivacy) {
        self.startAt = start
        self.endAt = end
        self.privacy = privacy
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(startAt?.timeText ?? "--")
            Text(" - \(endAt?.timeText ?? "--")")
                .opacity(0.7)
                .padding(.trailing, 16)
            Text(startAt?.dayText ?? "--")
                .padding([.leading, .trailing], 8)
                .padding([.top, .bottom], 4)
                .background(Color.white.cornerRadius(14))
                .foregroundColor(privacy.backgroundColor)
                .padding(6)
            Text(startAt?.monthText ?? "--")
            Text(String.dotText)
                .padding([.leading, .trailing], 10)
            privacy.typeImage
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
            Spacer()
        }
        .padding(.leading, 12)
        .background(privacy.backgroundColor.padding(.bottom, -70))
        .foregroundColor(.white)
        .font(Font.system(.footnote).weight(.semibold))
    }
}


fileprivate extension InvitationPrivacy {
    
    var backgroundColor: Color {
        switch self {
        case .open:
            return Color.openInvitation
        case .direct:
            return Color.directInvitation
        case .matched:
            return Color.matched
        }
    }
    
    var typeImage: Image {
        switch self {
        case .open:
            return Image("globe")
        case .direct:
            return Image(systemName: "person.2.fill")
        case .matched:
            return Image(systemName: "sparkles")
        }
        
    }
}


struct TimeHeader_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        let snapshot = invitation.asSnapshot(in: .defaultStack)!
        TimeHeader(start: snapshot.$startAt, end: snapshot.$endAt, privacy: snapshot.privacy)
    }
}
