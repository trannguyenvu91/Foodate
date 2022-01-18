//
//  Sequence.swift
//  Foodate
//
//  Created by Vu Tran on 1/18/22.
//

import Foundation
import CoreStore

extension Sequence where Element: CoreStoreObject {
    func asSnapshots() -> [ObjectSnapshot<Element>] {
        compactMap({ $0.asSnapshot(in: .defaultStack) })
    }
    
    func asPublishers() -> [ObjectPublisher<Element>] {
        compactMap({ $0.asPublisher(in: .defaultStack) })
    }
}
