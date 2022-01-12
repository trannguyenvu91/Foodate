//
//  NetworkResource.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/17/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Alamofire
import Combine
import Foundation

struct NetworkResource<Result> where Result: ImportableJSONObject {
    
    let method: HTTPMethod
    let params: JSON?
    let api: String
    
    var urlPath: String {
        return NetworkConfig.baseURL + api
    }
    
    func request() async throws -> Result {
        let response = try await NetworkService.shared.request(url: urlPath,
                                                        method: method,
                                                        parameters: params)
        return try Result.importObject(from: response)
    }
    
}
