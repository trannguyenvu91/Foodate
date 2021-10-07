//
//  NetworkPage.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/18/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkPage: ImportableJSONObject {
    static func importObject(from source: JSON) throws -> NetworkPage<T> {
        NetworkPage<T>(
            nextURL: source["next"] as? String,
            results: try T.importObjects(from: source["results"] as? [JSON] ?? [])
        )
    }
    
}

struct NetworkPage<T> where T: ImportableJSONObject {
    
    let nextURL: String?
    let results: [T]?
    let params: JSON?
    
    enum CodingKeys: String, CodingKey {
        case nextURL = "next", results
    }
    
    init(nextURL: String?, results: [T]?, params: JSON? = nil) {
        self.nextURL = nextURL
        self.params = params
        self.results = results
    }
    
    func fetchNext() async throws -> NetworkPage<T> {
        guard let nextUrl = nextURL else {
            throw NetworkError(code: 999, message: "There is not a next page")
        }
        let response = try await NetworkService.request(url: nextUrl,
                                                        method: .get,
                                                        parameters: params)
        return try NetworkPage<T>.importObject(from: response)
    }
    
}
