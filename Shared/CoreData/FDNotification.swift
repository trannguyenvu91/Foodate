//
//  FDNotification.swift
//  Foodate
//
//  Created by Vu Tran on 12/14/21.
//

import Foundation
import CoreStore
import ObjectMapper

extension FDNotification: ImportableUniqueObject, ImportableJSONObject {
    
    static var uniqueIDKeyPath: String {
        "id"
    }
    
    static func uniqueID(from source: JSON, in transaction: BaseDataTransaction) throws -> Int? {
        source["id"] as? Int
    }
    
    func update(from source: JSON, in transaction: BaseDataTransaction) throws {
        let map = Map(mappingType: .fromJSON, JSON: source)
        id <- map["id"]
        type <- map["type"]
        created <- (map["created"], FDDateTransform())
        sender = try transaction.importUniqueObject(Into<FDUser>(), source: (source["sender"] as? JSON)!)
        invitation = try transaction.importUniqueObject(Into<FDBaseInvitation>(), source: (source["invitation"] as? JSON)!)
    }
    
    typealias UniqueIDType = Int
    typealias ImportSource = JSON
    
}
