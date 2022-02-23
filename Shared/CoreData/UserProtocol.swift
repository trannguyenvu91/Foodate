//
//  UserProtocol.swift
//  Foodate
//
//  Created by Vu Tran on 1/17/22.
//

import CoreStore

protocol UserProtocol {
    var imageURL: String { get }
    var name: String { get }
    var id: Int { get }
}

extension UserProtocol {
    var userProfile: FDUserProfile {
        get throws {
            if let profile = try LibraryAPI.shared.fetchOne(FDUserProfile.self, id: id) {
                return profile
            }
            let profile = try DataStack.defaultStack.perform { transaction -> FDUserProfile in
                let profile = transaction.create(Into<FDUserProfile>())
                let photo = transaction.create(Into<FDPhoto>())
                profile.id = id
                profile.firstName = name
                photo.baseURL = imageURL
                profile.photos = [photo]
                return profile
            }
            return profile
        }
    }
}
