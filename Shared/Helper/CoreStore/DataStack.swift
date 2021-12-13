//
//  DataStack.swift
//  Foodate
//
//  Created by Vu Tran on 12/9/21.
//

import CoreStore

extension DataStack {
    class var defaultStack: DataStack {
        return FDCoreStore.shared.dataStack
    }
}
