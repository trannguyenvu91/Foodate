//
//  ImportableJSONObject.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import CoreStore

extension CoreStoreObject {
    class func fetchOne(_ fetchClauses: FetchClause...) throws -> Self? {
        try FDCoreStore.shared.dataStack.fetchOne(From<Self>())
    }
    
}
