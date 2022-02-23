//
//  UserBaseViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 16/07/2021.
//

import Foundation
import Combine
import CoreStore

protocol RemoteObject: ImportableUniqueObject {
    static func fetchRemoteObject(id: Self.UniqueIDType, success: SuccessCallback<Self>) async throws
}

class BaseObjectViewModel<Object>: BaseViewModel where Object: CoreStoreObject & RemoteObject {
    
    @Published var publisher: ObjectPublisher<Object>?
    var snapshot: ObjectSnapshot<Object>? {
        publisher?.asSnapshot(in: .defaultStack)
    }
    var objectID: Object.UniqueIDType
    
    init(_ object: Object) {
        publisher = object.asPublisher(in: .defaultStack)
        objectID = object.uniqueIDValue
        super.init()
    }
    
    init(_ publiser: ObjectPublisher<Object>) {
        publisher = publiser
        objectID = publiser.uniqueIDValue!
        super.init()
    }
    
    init(_ id: Object.UniqueIDType) {
        objectID = id
        super.init()
    }
    
    func loadObject() async throws {
        try await Object.fetchRemoteObject(id: objectID) { [weak self] object in
            self?.publisher = object.asPublisher(in: .defaultStack)
        }
    }
    
}
