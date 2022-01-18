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
    
    func loadObject<T: ImportableJSONObject>(source: String, ofType: String) -> T {
        let bundle = Bundle(for: type(of: self))
        let json = try! bundle.json(forResource: source, ofType: ofType)
        return try! T.importObject(from: json)
    }
    
    func loadObjectPublisher<T: ImportableJSONObject & CoreStoreObject>(source: String, ofType: String) -> ObjectPublisher<T> {
        let object: T = loadObject(source: source, ofType: ofType)
        return object.asPublisher(in: .defaultStack)
    }
    
    func loadUser<U: FDUser>() -> ObjectPublisher<U> {
        loadObjectPublisher(source: "session_user", ofType: "json")
    }
    
    func loadPlace() -> ObjectPublisher<FDPlace> {
        loadObjectPublisher(source: "place", ofType: "json")
    }
    
    func loadInvitation() -> ObjectPublisher<FDInvitation> {
        loadObjectPublisher(source: "invitation", ofType: "json")
    }
    
    func loadRequester() -> ObjectPublisher<FDRequester> {
        loadObjectPublisher(source: "requester", ofType: "json")
    }
}
