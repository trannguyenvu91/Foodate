//
//  FDInvitation.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore
import ObjectMapper

extension ObjectSnapshot where O: FDInvitation {
    
    var action: InvitationAction {
        let toUser = self.$toUser?.asSnapshot(in: .defaultStack)
        let owner = self.$owner?.asSnapshot(in: .defaultStack)
        if toUser?.isSession == true, self.$state == .pending {
            return .reply
        }
        if let toUser = toUser {
            return .viewReply(toUser)
        }
        if owner?.isSession == true {
            if self.$requestsTotal ?? 0 > 0 {
                return .viewRequests
            }
            return .invite
        }
        return .request
    }
    
    var isRequested: Bool {
        self.$requests.compactMap({ $0.asSnapshot(in: .defaultStack) })
            .contains(where: { $0.isSession })
    }
    
}

extension FDBaseInvitation: ImportableUniqueObject, ImportableJSONObject {
    
    typealias UniqueIDType = Int
    typealias ImportSource = JSON
    static var uniqueIDKeyPath: String {
        #keyPath(FDBaseInvitation.id)
    }
    
    static func uniqueID(from source: JSON, in transaction: BaseDataTransaction) throws -> Int? {
        source[uniqueIDKeyPath] as? Int
    }
    
}

extension FDInvitation: RemoteObject {
    static func fetchRemoteObject(id: Int) async throws -> Self {
        try await LibraryAPI.shared.getInvitation(ID: id) as! Self
    }
    
}
