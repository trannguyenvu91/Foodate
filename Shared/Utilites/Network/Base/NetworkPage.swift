//
//  NetworkPage.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/18/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Combine
import Foundation
import Alamofire

extension NetworkPage: ImportableJSONObject {
    static func importObject(from source: JSON) throws -> NetworkPage<T> {
        NetworkPage<T>(
            nextURL: source["next"] as? String,
            results: try T.importObjects(from: source["results"] as? [JSON] ?? [])
        )
    }
    
    init(nextURL: String?, results: [T]?, params: JSON? = nil) {
        if let path = nextURL,
           var components = URLComponents(string: path),
           let queryItems = params?.map({ URLQueryItem(name: $0.key, value: "\($0.value)") }) {
            components.queryItems?.append(contentsOf: queryItems)
            self.nextURL = components.path
        } else {
            self.nextURL = nextURL
        }
        self.results = results
    }
    
}

struct NetworkPage<T> where T: ImportableJSONObject {
    
    let nextURL: String?
    let results: [T]?
    
    enum CodingKeys: String, CodingKey {
        case nextURL = "next", results
    }
    
    func fetchNext() -> AnyPublisher<NetworkPage<T>, Error> {
        guard let nextUrl = nextURL else {
            return Fail(outputType: NetworkPage<T>.self,
                        failure: NetworkError(code: 999, message: "There is not a next page"))
                .eraseToAnyPublisher()
        }
        return NetworkService.requestPubliser(url: nextUrl,
                                              method: .get,
                                              parameters: nil)
            .tryMap({ try NetworkPage<T>.importObject(from: $0) })
            .eraseToAnyPublisher()
    }
    
}
