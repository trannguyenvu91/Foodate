//
//  CoreStore.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore

extension DataStack {
    class var defaultStack: DataStack {
        return FDCoreStore.shared.dataStack
    }
}

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
        try dataStack.fetchAll(From<FDSessionUser>()).first?.asSnapshot()
    }
    
}


