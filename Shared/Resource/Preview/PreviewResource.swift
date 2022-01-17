//
//  PreviewResource.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import CoreStore

class PreviewResource: NSObject {
    static let shared = PreviewResource()
    static let test = PreviewResource(.test)
    
    convenience init(_ store: SQLiteStore = .preview) {
        self.init()
        try? FDCoreStore.shared.setup(store)
    }
    
    func loadObject<T: ImportableJSONObject>(source: String, type: String, in bundle: Bundle = .main) -> T {
        let json = try! bundle.json(forResource: source, ofType: type)
        return try! T.importObject(from: json)
    }
    
    func loadObjectPublisher<T: ImportableJSONObject & CoreStoreObject>(source: String, type: String) -> ObjectPublisher<T> {
        let object: T = loadObject(source: source, type: type)
        return object.asPublisher(in: .defaultStack)
    }
    
    func loadUser<U: FDUser>() -> ObjectPublisher<U> {
        loadObjectPublisher(source: "session_user", type: "json")
    }
    
    func loadPlace() -> ObjectPublisher<FDPlace> {
        loadObjectPublisher(source: "place", type: "json")
    }
    
    func loadInvitation() -> ObjectPublisher<FDInvitation> {
        loadObjectPublisher(source: "invitation", type: "json")
    }
    
    func loadRequester() -> ObjectPublisher<FDRequester> {
        loadObjectPublisher(source: "requester", type: "json")
    }
}
