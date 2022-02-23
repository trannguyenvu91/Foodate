//
//  PersistanceService.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore
import CoreData


enum PersistanceError: Error {
    case returnNilObject
}

class PersistanceService {
    
    var dataStack: DataStack {
        CoreStoreDefaults.dataStack
    }
    
    init(_ store: SQLiteStore = .production) throws {
        CoreStoreDefaults.dataStack = DataStack(CoreStoreSchema.v1)
        try dataStack.addStorageAndWait(store)
    }
    
    func fetchOne<O>(_ type: O.Type,
                     condition: Where<O> = .init(true)) throws -> O? where O: CoreStoreObject {
        try dataStack.fetchOne(
            From<O>()
                .where(condition)
        )
    }
    
    func fetchAll<O>(_ type: O.Type,
                     condition: Where<O> = .init(true)) throws -> [O] where O: CoreStoreObject {
        try dataStack.fetchAll(
            From<O>()
                .where(condition)
        )
    }
    
    @discardableResult
    func deleteAll<O>(_ type: O.Type,
                      condition: Where<O> = .init(true)) throws -> Int where O: CoreStoreObject {
        try dataStack.perform(synchronous: { transaction in
            try transaction.deleteAll(From<O>(), condition)
        })
    }
    
    @discardableResult
    func saveUniqueObject<O>(_ type: O.Type,
                             from source: O.ImportSource) throws -> O where O: CoreStoreObject & ImportableUniqueObject {
        let object = try dataStack.perform(synchronous: { transaction in
            try transaction.importUniqueObject(Into<O>(), source: source)
        })
        guard let object = object else {
            throw PersistanceError.returnNilObject
        }
        return object
    }
    
    @discardableResult
    func saveUniqueObjects<O>(_ type: O.Type,
                              from source: [O.ImportSource]) throws -> [O] where O: CoreStoreObject & ImportableUniqueObject {
        try dataStack.perform(synchronous: { transaction in
            try transaction.importUniqueObjects(Into<O>(), sourceArray: source)
        })
    }
    
    @discardableResult
    func saveObject<O>(_ type: O.Type,
                             from source: O.ImportSource) throws -> O where O: CoreStoreObject & ImportableObject {
        let object = try dataStack.perform(synchronous: { transaction in
            try transaction.importObject(Into<O>(), source: source)
        })
        guard let object = object else {
            throw PersistanceError.returnNilObject
        }
        return object
    }
    
    @discardableResult
    func saveObjects<O>(_ type: O.Type,
                              from source: [O.ImportSource]) throws -> [O] where O: CoreStoreObject & ImportableObject {
        try dataStack.perform(synchronous: { transaction in
            try transaction.importObjects(Into<O>(), sourceArray: source)
        })
    }
    
}
