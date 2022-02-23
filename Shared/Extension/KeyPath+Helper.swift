//
//  KeyPath+Helper.swift
//  Foodate
//
//  Created by Vu Tran on 2/23/22.
//

import Foundation

func setter<Object: AnyObject, Value>(object: Object,
                                      keyPath: WritableKeyPath<Object, Value?>) -> (Value?) -> () {
    return { [weak object] value in
        DispatchQueue.main.async {
            object?[keyPath: keyPath] = value
        }
    }
}
