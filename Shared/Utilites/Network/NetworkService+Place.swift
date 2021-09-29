//
//  NetworkService+Place.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import Foundation

extension NetworkService {
    
    class func getPlace(ID: String) async throws -> FDPlace {
        try await NetworkResource(method: .get,
                                  params: nil,
                                  api: "/api/v1/places/\(ID)/")
            .request()
    }
    
}
