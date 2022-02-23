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
    @ClockService var updatedTime
    
    var body: some View {
        ObjectReader(notification) { snapshot in
            VStack(alignment: .leading) {
                NavigationButton(
                    destination: LazyView(
                        UserProfileView(model: .init(snapshot.$sender!.id!))
                    )
                ) {
                    senderView(snapshot)
                }
                NavigationButton(destination: LazyView(InvitationView(model: .init(snapshot.$invitation?.$id ?? 0)))) {
                    invitationTitleView(snapshot)
                }
                .padding(.top, -8)
                .padding(.bottom)
            }
        }
    }
    
    func invitationTitleView(_ noti: ObjectSnapshot<FDNotification>) -> some View {
        let invitation = noti.$invitation?.asSnapshot(in: .defaultStack)
        let inviter = invitation?.$owner?.asSnapshot(in: .defaultStack)
        return HStack(alignment: .bottom, spacing: 4) {
            Text("\"\(invitation?.$title ?? "")\"")
                .font(.callout)
                .fontWeight(.ultraLight)
                .fixedSize(horizontal: false, vertical: true)
                .padding(8)
                .background(Color.groupTableViewBackground)
                .clipShape(.rounded([.topLeft, .topRight, .bottomLeft], radius: 18))
            CircleView(
                ASRemoteImageView(path: inviter?.imageURL)
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
            )
                .onAppear(perform: {
                    ASRemoteImageManager.shared.load(path: inviter?.imageURL)
                })
                .frame(width: 30, height: 30)
            Spacer()
        }
        .padding(.leading, 48)
    }
    
    func senderView(_ noti: ObjectSnapshot<FDNotification>) -> some View {
        let sender = noti.$sender?.asSnapshot(in: .defaultStack)
        return HStack {
            CircleView(
                ASRemoteImageView(path: sender?.imageURL)
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
            )
                .onAppear(perform: {
                    ASRemoteImageManager.shared.load(path: sender?.imageURL)
                })
                .frame(width: 40, height: 40)
                .overlay(alignment: .bottomTrailing) {
                    typeIconView(noti)
                }
            HStack {
                Text(sender?.name ?? "")
                    .fontWeight(.semibold) + detailText(noti)
            }
            Spacer()
            Text(noti.$created?.distanceString ?? "")
                .foregroundColor(.lightGray)
                .font(.footnote)
        }
    }
    
    func detailText(_ noti: ObjectSnapshot<FDNotification>) -> Text {
        let (detail, _, _) = (noti.$type ?? .updatedInvitation).detail
        return Text(" " + detail)
    }
    
    func typeIconView(_ noti: ObjectSnapshot<FDNotification>) -> some View {
        let (_, imageName, color) = (noti.$type ?? .updatedInvitation).detail
        return Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 18, height: 18)
            .background(Color.white)
            .foregroundColor(color)
            .clipShape(Circle())
    }
    
}

struct NotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        let notification: FDNotification = PreviewResource.shared.loadObject(source: "notification", ofType: "json")
        NotificationCell(notification: notification.asPublisher(in: .defaultStack))
            .previewDevice("iPhone 13 mini")
    }
}
