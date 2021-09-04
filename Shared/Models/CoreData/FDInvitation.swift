//
//  FDInvitation.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore

enum FDInvitationState: String {
    case pending = "pending"
    case matched = "matched"
    case canceled = "canceled"
    case archived = "archived"
    case rejected = "rejected"
    
    var description: String {
        switch self {
        case .pending:
            return "Đã gửi"
        case .matched:
            return "Sẽ tham gia"
        case .archived:
            return "Đã xoá"
        case .canceled:
            return "Đã huỷ"
        case .rejected:
            return "Đã từ chối"
        }
    }
}

enum InvitationAction {
    case viewReply(ObjectSnapshot<FDUser>)
    case viewRequests
    case invite
    case request
    case reply
}

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

extension FDInvitation: ImportableUniqueObject, ImportableJSONObject {
    static var uniqueIDKeyPath: String {
        #keyPath(FDInvitation.id)
    }
    
    static func uniqueID(from source: JSON, in transaction: BaseDataTransaction) throws -> Int? {
        source[uniqueIDKeyPath] as? Int
    }
    
    func update(from source: JSON, in transaction: BaseDataTransaction) throws {
        id = source["id"] as? Int ?? 0
        title = source["title"] as? String
        startAt = DateFormatter.standard.date(from: source["start_at"] as? String ?? "")
        endAt = DateFormatter.standard.date(from: source["end_at"] as? String ?? "")
        state = FDInvitationState(rawValue: source["state"] as? String ?? "")
        shareBill = FDShareBill(rawValue: source["share_bill"] as? String ?? "")
        requestsTotal = source["requests_total"] as? Int ?? 0
        owner = try transaction.importUniqueObject(Into<FDUser>(), source: (source["owner"] as? JSON)!)
        if let toUserInfo = source["to_user"] as? JSON {
            toUser = try transaction.importUniqueObject(Into<FDUser>(), source: toUserInfo)
        }
        place = try transaction.importUniqueObject(Into<FDPlace>(), source: (source["place"] as? JSON)!)
        requests = try transaction.importUniqueObjects(Into<FDRequester>(), sourceArray: source["requests"] as? [JSON] ?? [])
    }
    
    typealias UniqueIDType = Int
    typealias ImportSource = JSON
    
    static func importObject(from source: JSON) throws -> Self {
        try DataStack.defaultStack.perform { transaction in
            try transaction.importUniqueObject(Into<Self>(), source: source)!
        }
    }
    
}
