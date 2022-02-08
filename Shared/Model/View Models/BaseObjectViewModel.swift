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
    static func fetchRemoteObject(id: Self.UniqueIDType) async throws -> Self
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
    
    @MainActor
    func loadObject() async throws {
        if let local = try fetchLocalObject() {
            publisher = local
        }
        let remote = try await fetchRemoteObject()
        publisher = remote
    }
    
    @MainActor
    func fetchLocalObject() throws -> ObjectPublisher<Object>? {
        try FDCoreStore.shared
            .fetchOne(
                Where<Object>(Object.uniqueIDKeyPath, isEqualTo: objectID)
            )?
            .asPublisher()
    }
    
    func fetchRemoteObject() async throws -> ObjectPublisher<Object> {
        try await Object.fetchRemoteObject(id: objectID).asPublisher(in: .defaultStack)
    }
    
}
