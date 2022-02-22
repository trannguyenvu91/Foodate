//
//  ImportableJSONObject.swift
//  Foodate
//
//  Created by Vu Tran on 1/24/22.
//

import Foundation

protocol ImportableJSONObject {
    static func importObject(from source: JSON) throws -> Self
}

extension ImportableJSONObject {
    
    static func importObjects(from sourceArry: [JSON]) throws -> [Self] {
        try sourceArry.map({ try importObject(from: $0) })
    }
}
