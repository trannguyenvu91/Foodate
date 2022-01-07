//
//  UserHeader.swift
//  Foodate
//
//  Created by Vu Tran on 22/07/2021.
//

import SwiftUI
import CoreStore

protocol UserProtocol {
    var imageURL: String { get }
    var name: String { get }
    var id: Int { get }
}

struct UserHeader: View {
    
    var user: UserProtocol
    init(_ user: UserProtocol) {
        self.user = user
    }
    
    var body: some View {
        GeometryReader { proxy in
            NavigationButton(destination: LazyView(UserProfileView(model: .init(user.userProfile)))) {
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

extension UserProtocol {
    var userProfile: ObjectPublisher<FDUserProfile> {
        if let profile = try? FDUserProfile.fetchOne(id: id)?.asPublisher() {
            return profile
        }
        let profile = try! DataStack.defaultStack.perform { transaction -> FDUserProfile in
            let profile = transaction.create(Into<FDUserProfile>())
            let photo = transaction.create(Into<FDPhoto>())
            profile.id = id
            profile.firstName = name
            photo.baseURL = imageURL
            profile.photos = [photo]
            return profile
        }
        return profile.asPublisher(in: .defaultStack)
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
