//
//  DataStack.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import CoreStore

extension DataStack {
    class var defaultStack: DataStack {
        LibraryAPI.shared.dataStack
    }
}

extension SQLiteStore {
    static var production: SQLiteStore = {
        SQLiteStore(fileName: "com.foodate.Foodate.sqlite")
    }()
    
    static var preview: SQLiteStore = {
        SQLiteStore(fileName: "preview.com.foodate.Foodate.sqlite")
    }()
    
    static var test: SQLiteStore = {
        SQLiteStore(fileName: "test.com.foodate.Foodate.sqlite")
    }()
    
}
