//
//  FDPhoto.swift
//  Foodate
//
//  Created by Vu Tran on 13/07/2021.
//

import Foundation
import CoreStore

extension FDPhoto: ImportableObject {
    
    typealias ImportSource = String
    func didInsert(from source: String, in transaction: BaseDataTransaction) throws {
        baseURL = source
    }
    
}

extension FDPlacePhoto: ImportableObject {
    typealias ImportSource = JSON
    func didInsert(from source: JSON, in transaction: BaseDataTransaction) throws {
        baseURL = source["base_url"] as? String
        width = source["width"] as? Double
        height = source["height"] as? Double
    }
    
}
