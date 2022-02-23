//
//  ImportableJSONObject+CoreStore.swift
//  Foodate
//
//  Created by Vu Tran on 2/22/22.
//

import Foundation
import CoreStore

extension ImportableJSONObject where Self: CoreStoreObject & ImportableObject,
                                     Self.ImportSource == JSON {
    static func importObject(from source: JSON) throws -> Self {
        try LibraryAPI.shared.saveObject(Self.self, from: source)
    }
    static func importObjects(from sourceArry: [JSON]) throws -> [Self] {
        try LibraryAPI.shared.saveObjects(Self.self, from: sourceArry)
    }
    
}

extension ImportableJSONObject where Self: CoreStoreObject & ImportableUniqueObject,
                                     Self.ImportSource == JSON {
    
    static func importUniqueObject(from source: JSON) throws -> Self {
        try LibraryAPI.shared.saveUniqueObject(Self.self, from: source)
    }
    static func importUniqueObjects(from sourceArry: [JSON]) throws -> [Self] {
        try LibraryAPI.shared.saveUniqueObjects(Self.self, from: sourceArry)
    }
    
}
