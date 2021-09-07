//
//  LocationTransform.swift
//  Foodate
//
//  Created by Vu Tran on 07/09/2021.
//

import Foundation
import ObjectMapper

class LocationTransform: TransformType {
    func transformFromJSON(_ value: Any?) -> FDLocation? {
        guard let str = value as? String else { return nil }
        return try? FDLocation(from: str)
    }
    
    func transformToJSON(_ value: FDLocation?) -> String? {
        value?.toString
    }
    
    typealias Object = FDLocation
    typealias JSON = String
    
}
