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
            try LibraryAPI.shared.fetchUserProfile(from: self)
        }
    }
}

internal extension LibraryAPI {
    func fetchUserProfile(from user: UserProtocol) throws -> FDUserProfile {
        if let profile = try LibraryAPI.shared.fetchOne(FDUserProfile.self, id: user.id) {
            return profile
        }
        let profile = try dataStack.perform { transaction -> FDUserProfile in
            let profile = transaction.create(Into<FDUserProfile>())
            let photo = transaction.create(Into<FDPhoto>())
            profile.id = user.id
            profile.firstName = user.name
            photo.baseURL = user.imageURL
            profile.photos = [photo]
            return profile
        }
        return profile
    }
}
