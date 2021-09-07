//
//  FDPhoto.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore
import ObjectMapper

extension FDPhoto: ImportableObject {
    
    typealias ImportSource = String
    func didInsert(from source: String, in transaction: BaseDataTransaction) throws {
        baseURL = source
    }
    
}

extension FDPlacePhoto: ImportableObject {
    
    typealias ImportSource = JSON
    
    func didInsert(from source: JSON, in transaction: BaseDataTransaction) throws {
        let map = Map(mappingType: .fromJSON, JSON: source)
        baseURL <- map["base_url"]
        width <- map["width"]
        height <- map["height"]
    }
    
}
