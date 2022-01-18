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
        self.$id == AppSession.shared.sessionUser?.$id
    }
    
    var id: Int {
        self.$id
    }
    
}

extension ObjectPublisher where O: FDBaseUser {
    var isSession: Bool {
        self.$id == AppSession.shared.sessionUser?.$id
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
    
    class func fetchOne(id: Int) throws -> FDUserProfile? {
        let user: FDUserProfile? = try DataStack.defaultStack.fetchOne(
            From<FDUserProfile>(),
            Where(\FDUser.$id == id)
        )
        return user
    }

    static func fetchRemoteObject(id: Int) async throws -> Self {
        try await NetworkService.getUser(ID: id) as! Self
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
    
    
    static func importObject(from source: JSON) throws -> Self {
        try DataStack.defaultStack.perform { transaction in
            try transaction.importUniqueObject(Into<Self>(), source: source)!
        }
    }
}
