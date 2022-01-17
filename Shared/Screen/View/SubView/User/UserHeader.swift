//
//  UserHeader.swift
//  Foodate
//
//  Created by Vu Tran on 22/07/2021.
//

import SwiftUI
import CoreStore

struct UserHeader: View {
    
    var user: UserProtocol
    init(_ user: UserProtocol) {
        self.user = user
    }
    
    var body: some View {
        GeometryReader { proxy in
            NavigationButton(destination: LazyView(
                UserProfileView(model: .init(user.id))
            )
            ) {
                HStack {
                    CircleView(
                        ASRemoteImageView(path: self.user.imageURL)
                            .scaledToFill()
                            .aspectRatio(1, contentMode: .fit)
                    )
                    .frame(width: proxy.size.height, height: proxy.size.height)
                    .onAppear {
                        ASRemoteImageManager.shared.load(path: self.user.imageURL)
                    }
                    Text(user.name)
                        .fontWeight(.medium)
                }
            }
        }
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        let user: ObjectPublisher<FDUserProfile> = PreviewResource.shared
            .loadUser()
        UserHeader(user.asSnapshot(in: .defaultStack)!)
        .height(50)
        .scaledToFit()
    }
}
