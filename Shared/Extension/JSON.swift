//
//  JSON.swift
//  Foodate
//
//  Created by Vu Tran on 1/12/22.
//

import Foundation

extension JSON: ImportableJSONObject {
    static func importObject(from source: JSON) throws -> JSON {
        source
    }
    
    func nullified() -> JSON {
        return self.filter({ type(of: $0.key) != NSNull.self && type(of: $0.value) != NSNull.self })
    }
}
