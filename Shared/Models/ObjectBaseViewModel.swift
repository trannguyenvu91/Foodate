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
    
    var objectPubliser: ObjectPublisher<T>!
    
    convenience init(_ object: T) {
        self.init()
        objectPubliser = object.asPublisher(in: .defaultStack)
    }
    
    convenience init(_ publiser: ObjectPublisher<T>) {
        self.init()
        objectPubliser = publiser
    }
}

