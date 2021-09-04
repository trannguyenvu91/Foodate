//
//  TimeHeader.swift
//  Foodate
//
//  Created by Vu Tran on 23/07/2021.
//

import SwiftUI
import CoreStore

struct TimeHeader: View {
    
    var invitation: ObjectSnapshot<FDInvitation>
    
    init(_ invitation: ObjectSnapshot<FDInvitation>) {
        self.invitation = invitation
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(invitation.$startAt?.timeText ?? "--")
            Text(" - \(invitation.$endAt?.timeText ?? "--")")
                .opacity(0.7)
                .padding(.trailing, 16)
            Text(invitation.$startAt?.dayText ?? "--")
                .padding([.leading, .trailing], 8)
                .padding([.top, .bottom], 4)
                .background(Color.white.cornerRadius(14))
                .foregroundColor(invitation.backgroundColor)
                .padding(6)
            Text(invitation.$startAt?.monthText ?? "--")
            Text(String.dotText)
                .padding([.leading, .trailing], 10)
            invitation.typeImage
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
            Spacer()
        }
        .padding(.leading, 12)
        .background(invitation.backgroundColor.padding(.bottom, -70))
        .foregroundColor(.white)
        .font(Font.system(.footnote).weight(.semibold))
    }
}

fileprivate extension ObjectSnapshot where O: FDInvitation {
    
    var backgroundColor: Color {
        switch self.$state {
        case .matched:
            return .matched
        case .rejected:
            return .rejected
        case .archived:
            return .archived
        case .canceled:
            return .canceled
        case .pending:
            return (self.$toUser == nil) ? .openInvitation : .directInvitation
        case .none:
            return .lightGray
        }
    }
        
    var typeImage: Image {
        if self.$state == .matched {
            return Image(systemName: "sparkles")
        } else if let _ = self.$toUser {
            return Image(systemName: "person.2.fill")
        }
        return Image("globe")
    }
        
}

struct TimeHeader_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        let snapshot = invitation.asSnapshot(in: .defaultStack)!
        TimeHeader(snapshot)
    }
}
