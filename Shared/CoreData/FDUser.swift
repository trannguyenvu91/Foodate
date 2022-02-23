//
//  FDUser.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore

extension ObjectSnapshot: UserProtocol where O: FDBaseUser {
    var imageURL: String {
        self.$avatarURL ?? ""
    }
    
    var name: String {
        (self.$firstName ?? "") + " " + (self.$lastName ?? "")
    }
    
    var isSession: Bool {
        self.$id == LibraryAPI.shared.userSnapshot?.$id
    }
    
    var id: Int {
        self.$id
    }
    
}

extension ObjectPublisher where O: FDBaseUser {
    var isSession: Bool {
        self.$id == LibraryAPI.shared.userSnapshot?.$id
    }
}

extension ObjectSnapshot where O: FDUserProfile {
    
    var age: Int? {
        if let birthday = self.$birthday {
            return birthday.ageFromBirth()
        }
        return nil
    }
    
}

extension FDUserProfile: RemoteObject {
    static func fetchRemoteObject(id: Int, success: SuccessCallback<FDUserProfile>) async throws {
        try await LibraryAPI.shared.getUser(ID: id, success: success)
    }
    
}

extension FDUser: ImportableUniqueObject, ImportableJSONObject {
    
    static var uniqueIDKeyPath: String {
        "id"
    }
    
    static func uniqueID(from source: JSON, in transaction: BaseDataTransaction) throws -> Int? {
        source[uniqueIDKeyPath] as? Int
    }
    
    typealias UniqueIDType = Int
    typealias ImportSource = JSON
    
}
