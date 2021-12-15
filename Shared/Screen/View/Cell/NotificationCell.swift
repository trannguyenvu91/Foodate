//
//  NotificationCell.swift
//  Foodate
//
//  Created by Vu Tran on 12/15/21.
//

import SwiftUI
import CoreStore

struct NotificationCell: View {
    
    var notification: ObjectPublisher<FDNotification>!
    
    var body: some View {
        ObjectReader(notification) { snapshot in
            VStack(alignment: .leading) {
                senderView(snapshot)
                invitationTitleView(snapshot)
                    .padding(.top, -8)
            }
        }
        .padding(.bottom)
    }
    
    func invitationTitleView(_ noti: ObjectSnapshot<FDNotification>) -> some View {
        let invitation = noti.$invitation?.asSnapshot(in: .defaultStack)
        let inviter = invitation?.$owner?.asSnapshot(in: .defaultStack)
        return Text("\"\(invitation?.$title ?? "")\"")
            .font(.callout)
            .fontWeight(.ultraLight)
            .fixedSize(horizontal: false, vertical: true)
            .padding(8)
            .background(Color.groupTableViewBackground)
            .cornerRadius(4)
            .padding(.leading, 48)
            .overlay(alignment: .bottomTrailing) {
                CircleView(
                    ASRemoteImageView(path: inviter?.imageURL)
                        .scaledToFill()
                        .aspectRatio(1, contentMode: .fit)
                )
                    .frame(width: 30, height: 30)
                    .padding([.bottom, .trailing], -16)
            }
    }
    
    func senderView(_ noti: ObjectSnapshot<FDNotification>) -> some View {
        let sender = noti.$sender?.asSnapshot(in: .defaultStack)
        return HStack {
            CircleView(
                ASRemoteImageView(path: sender?.imageURL)
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
            )
                .frame(width: 40, height: 40)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "arrowshape.turn.up.forward.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .background(Color.white)
                        .foregroundColor(.orange)
                        .clipShape(Circle())
                }
            VStack(alignment: .leading) {
                HStack {
                    Text(sender?.name ?? "")
                        .fontWeight(.semibold)
                    detailText(noti)
                }
                Text(noti.$created?.distanceString ?? "")
                    .foregroundColor(.lightGray)
                    .font(.footnote)
            }
            Spacer()
        }
    }
    
    func detailText(_ noti: ObjectSnapshot<FDNotification>) -> some View {
        let invitation = noti.$invitation?.asSnapshot(in: .defaultStack)
        var detail = ""
        switch noti.$type {
        case .newRequest:
            detail = "sent you a join request."
        default:
            switch invitation?.$state {
            case .pending:
                detail = "sent you an invitation"
            case .matched:
                detail = "have an event with you"
            default:
                detail = "update state to: \(invitation?.$state?.rawValue ?? "--")"
            }
        }
        return Text(detail)
    }
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        let notification: FDNotification = PreviewResource.shared.loadObject(source: "notification", type: "json")
        NotificationCell(notification: notification.asPublisher(in: .defaultStack))
    }
}
