//
//  NetworkService+Place.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import Foundation
import Combine


extension NetworkService {
    
    class func getPlace(ID: String) -> NetworkPublisher<FDPlace> {
        return NetworkResource(method: .get,
                               params: nil,
                               api: "/api/v1/places/\(ID)/")
            .requestPubliser()
            .tryImportObject()
    }
    
}
