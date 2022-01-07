//
//  MatchedView.swift
//  Foodate
//
//  Created by Vu Tran on 1/6/22.
//

import SwiftUI
import CoreStore

struct MatchedView: View {
    
    var invitation: ObjectSnapshot<FDInvitation>
    
    var body: some View {
        VStack {
            if let owner = invitation.$owner?.asSnapshot(in: .defaultStack) {
                HStack {
                    userView(owner)
                    Text(owner.name)
                        .font(.title)
                    Spacer()
                }
            }
            HStack {
                messageView(invitation.$title, rounded: [.topRight, .bottomLeft, .bottomRight])
                Spacer()
            }
            HStack {
                Spacer()
            Text("🎉🎉🎉")
                .font(.largeTitle)
                .padding([.trailing], 60)
            }
            if let recipient = invitation.$toUser?.asSnapshot(in: .defaultStack) {
                HStack {
                    Spacer()
                    Text(recipient.name)
                        .font(.title)
                    userView(recipient)
                }
            }
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            UIImpactFeedbackGenerator(style: .medium)
                .impactOccurred()
        }
    }
    
    func userView(_ user: ObjectSnapshot<FDUser>) -> some View {
        CircleView(
            CircleView(
                ASRemoteImageView(path: user.imageURL)
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
            )
                .frame(width: 60, height: 60)
                .onAppear {
                    ASRemoteImageManager.shared.load(path: user.imageURL)
                }
        )
    }
    
    func messageView(_ message: String?, rounded corners: UIRectCorner) -> some View {
        Text(message ?? "")
            .font(.headline)
            .foregroundColor(.white)
            .padding(20)
            .background(
                Color.blue
                    .clipShape(.rounded(corners, radius: 30))
            )
            .padding([.leading, .trailing], 60)
    }
    
}

struct MatchedView_Previews: PreviewProvider {
    static var previews: some View {
        let invitation = PreviewResource.shared.loadInvitation()
        MatchedView(invitation: invitation.asSnapshot(in: .defaultStack)!)
    }
}
