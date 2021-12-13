//
//  FDDateTransform.swift
//  Foodate
//
//  Created by Vu Tran on 07/09/2021.
//

import Foundation
import ObjectMapper

class FDDateTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> Date? {
        guard let str = value as? String else {
            return nil
        }
        return DateFormatter.standard.date(from: str)
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        guard let date = value else { return nil }
        return DateFormatter.standard.string(from: date)
    }
    
    typealias Object = Date
    typealias JSON = String
    
}
