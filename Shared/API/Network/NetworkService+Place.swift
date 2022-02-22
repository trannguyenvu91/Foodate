//
//  NetworkService+Place.swift
//  Foodate
//
//  Created by Vu Tran on 04/08/2021.
//

import Foundation

extension NetworkService {
    
    func getPlace(ID: String) async throws -> FDPlace {
        try await request(api: "/api/v1/places/\(ID)/",
                          method: .get,
                          parameters: nil)
    }
    
}
