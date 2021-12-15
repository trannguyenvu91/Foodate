//
//  FieldStorableTypes.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import CoreData
import CoreStore

extension FDBusinessStatus: FieldStorableType {
    
    static func cs_fromFieldStoredNativeType(_ value: String) -> FDBusinessStatus {
        FDBusinessStatus(rawValue: value) ?? .operational
    }
    
    func cs_toFieldStoredNativeType() -> Any? {
        rawValue
    }
    
    typealias FieldStoredNativeType = String
    
}

extension NotificationType: FieldStorableType {
    static func cs_fromFieldStoredNativeType(_ value: String) -> NotificationType {
        NotificationType(rawValue: value) ?? .newEvent
    }
    
    func cs_toFieldStoredNativeType() -> Any? {
        rawValue
    }
    
    typealias FieldStoredNativeType = String
    
}

extension FDShareBill: FieldStorableType {
    
    static func cs_fromFieldStoredNativeType(_ value: String) -> FDShareBill {
        FDShareBill(rawValue: value) ?? .fifty
    }
    
    func cs_toFieldStoredNativeType() -> Any? {
        rawValue
    }
    
    typealias FieldStoredNativeType = String
}

extension InvitationState: FieldStorableType {
    
    static func cs_fromFieldStoredNativeType(_ value: String) -> InvitationState {
        InvitationState(rawValue: value) ?? .archived
    }
    
    func cs_toFieldStoredNativeType() -> Any? {
        rawValue
    }
    
    typealias FieldStoredNativeType = String
}

typealias SimpleStringSet = Array<String>

extension SimpleStringSet: FieldStorableType {
    
    public typealias FieldStoredNativeType = String
    public static var cs_rawAttributeType: NSAttributeType {
        .stringAttributeType
    }
    
    public static func cs_fromFieldStoredNativeType(_ value: String) -> Array<Element> {
        value.split(separator: ",").map({ String($0) })
    }
    
    public func cs_toFieldStoredNativeType() -> Any? {
        joined(separator: ",")
    }
    
}
