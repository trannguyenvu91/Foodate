//
//  FDRequester.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore

extension FDRequester: ImportableUniqueObject, ImportableJSONObject {
    
    static var uniqueIDKeyPath: String {
        "request_id"
    }
    
    static func uniqueID(from source: JSON, in transaction: BaseDataTransaction) throws -> Int? {
        source[uniqueIDKeyPath] as? Int
    }
    
    typealias UniqueIDType = Int
    typealias ImportSource = JSON
    
}

