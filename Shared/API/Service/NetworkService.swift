//
//  NetworkService.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/14/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Alamofire


protocol ImportableJSONObject {
    static func importObject(from source: JSON) throws -> Self
    static func importObjects(from sourceArry: [JSON]) throws -> [Self]
}

protocol ServiceActor {
    func request(url: String,
                 method: HTTPMethod,
                 parameters: JSON?,
                 headers: HTTPHeaders?) async throws -> JSON
}

class NetworkService: NSObject {
    
    private(set) var actor: ServiceActor
    
    init(_ actor: ServiceActor) {
        self.actor = actor
    }
    
    func request<Result: ImportableJSONObject>(url: String,
                                               method: HTTPMethod,
                                               parameters: JSON?,
                                               headers: HTTPHeaders? = nil) async throws -> Result {
        let json = try await actor.request(url: url,
                                           method: method,
                                           parameters: parameters,
                                           headers: headers)
        return try Result.importObject(from: json)
    }
    
}

extension ImportableJSONObject {
    
    static func importObjects(from sourceArry: [JSON]) throws -> [Self] {
        try sourceArry.map({ try importObject(from: $0) })
    }
}

