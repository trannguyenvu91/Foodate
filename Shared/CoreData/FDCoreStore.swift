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
    
    func fetchSessionUser() throws -> ObjectSnapshot<FDSessionUser>? {
        try dataStack.fetchOne(
            From<FDSessionUser>()
        )?
            .asSnapshot(in: .defaultStack)
    }
    
    
    func fetchOne<O>(_ condition: Where<O>) throws -> O? where O: CoreStoreObject {
        try dataStack.fetchOne(
            From<O>()
                .where(condition)
        )
    }
    
}
