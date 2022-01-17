//
//  CoreStore.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore
import CoreData

class FDCoreStore {
    
    static let shared = FDCoreStore()
    var dataStack: DataStack {
        CoreStoreDefaults.dataStack
    }
    
    func setup(_ store: SQLiteStore = .production) throws {
        CoreStoreDefaults.dataStack = DataStack(CoreStoreSchema.v1)
        try dataStack.addStorageAndWait(store)
    }
    
    func fetchSessionUser() throws -> ObjectPublisher<FDSessionUser>? {
        try dataStack.fetchOne(
            From<FDSessionUser>()
        )?
            .asPublisher(in: .defaultStack)
    }
    
    func fetchOne<O>(_ condition: Where<O>) throws -> O? where O: CoreStoreObject {
        try dataStack.fetchOne(
            From<O>()
                .where(condition)
        )
    }
    
    @discardableResult
    func deleteAll<O>(_ condition: Where<O>) throws -> Int where O: CoreStoreObject {
        try dataStack.perform(synchronous: { transaction in
            try transaction.deleteAll(From<O>(), condition)
        })
    }
    
}
