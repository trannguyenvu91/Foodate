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
    
    func setup() {
        CoreStoreDefaults.dataStack = DataStack(CoreStoreSchema.v1)
        try! dataStack.addStorageAndWait(
            SQLiteStore(fileName: "com.foodate.Foodate.sqlite")
        )
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
