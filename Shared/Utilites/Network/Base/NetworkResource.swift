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

extension JSON {
    func nullified() -> JSON {
        return self.filter({ type(of: $0.key) != NSNull.self && type(of: $0.value) != NSNull.self })
    }
}

struct NetworkError: Error {
    let code: Int
    let message: String
    
    init(code: Int, message: String?) {
        self.code = code
        self.message = message ?? "The operation couldn't be completed. Please try again."
    }
    
}

struct NetworkResource {
    
    let method: HTTPMethod
    let params: JSON?
    let api: String
    
    var urlPath: String {
        return NetworkConfig.baseURL + api
    }
    
    func requestPubliser() -> JSONPublisher {
        return NetworkService.requestPubliser(url: urlPath,
                                              method: method,
                                              parameters: params)
    }
    
}

