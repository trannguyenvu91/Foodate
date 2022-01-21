//
//  NetworkPage.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/18/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkPage<Item> where Item: ImportableJSONObject {
    
    let nextURL: String?
    let results: [Item]?
    var params: JSON?
    
    enum CodingKeys: String, CodingKey {
        case nextURL = "next", results
    }
    
    init(nextURL: String?, results: [Item]? = nil, params: JSON? = nil) {
        self.nextURL = nextURL
        self.params = params
        self.results = results
    }
    
    func fetchNext() async throws -> NetworkPage<Item> {
        guard let nextUrl = nextURL else {
            throw NetworkError(code: 999, message: "There is not a next page")
        }
        let response = try await NetworkService.shared.request(url: nextUrl,
                                                        method: .get,
                                                        parameters: params)
        var nextPage = try NetworkPage<Item>.importObject(from: response)
        nextPage.params = params
        return nextPage
    }
    
}

extension NetworkPage: ImportableJSONObject {
    static func importObject(from source: JSON) throws -> NetworkPage<Item> {
        NetworkPage<Item>(
            nextURL: source["next"] as? String,
            results: try Item.importObjects(from: source["results"] as? [JSON] ?? [])
        )
    }
    
}
