//
//  UserBaseViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 16/07/2021.
//

import Foundation
import Combine
import CoreStore

class ObjectBaseViewModel<T>: BaseViewModel where T: CoreStoreObject {
    
    var objectPublisher: ObjectPublisher<T>!
    var objectSnapshot: ObjectSnapshot<T>!
    
    init(_ object: T) {
        super.init()
        objectPublisher = object.asPublisher(in: .defaultStack)
        objectSnapshot = object.asSnapshot(in: .defaultStack)
    }
    
    init(_ publiser: ObjectPublisher<T>) {
        super.init()
        objectPublisher = publiser
        objectSnapshot = publiser.asSnapshot(in: .defaultStack)
    }
}

