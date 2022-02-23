//
//  UserBaseViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 16/07/2021.
//

import Foundation
import Combine
import CoreStore

class BaseObjectViewModel<Object>: BaseViewModel where Object: CoreStoreObject & ImportableUniqueObject {
    
    var publisher: ObjectPublisher<Object>?
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
        fatalError("Must be implemented on specific Object")
    }
    
}

extension BaseObjectViewModel where Object == FDUserProfile {
    func loadObject() async throws {
        try await LibraryAPI.shared.getUser(ID: objectID) { object in
            DispatchQueue.main.async {  [weak self] in
                guard self?.publisher == nil else { return }
                self?.publisher = object.asPublisher(in: .defaultStack)
            }
        }
    }
}

extension BaseObjectViewModel where Object == FDInvitation {
    func loadObject() async throws {
        try await LibraryAPI.shared.getInvitation(ID: objectID) { object in
            DispatchQueue.main.async {  [weak self] in
                guard self?.publisher == nil else { return }
                self?.publisher = object.asPublisher(in: .defaultStack)
            }
        }
    }
}

extension BaseObjectViewModel where Object == FDPlace {
    func loadObject() async throws {
        try await LibraryAPI.shared.getPlace(ID: objectID) { object in
            DispatchQueue.main.async {  [weak self] in
                guard self?.publisher == nil else { return }
                self?.publisher = object.asPublisher(in: .defaultStack)
            }
        }
    }
}
