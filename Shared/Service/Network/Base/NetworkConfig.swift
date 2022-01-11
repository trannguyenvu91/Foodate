//
//  NetworkConfig.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/14/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Alamofire

private let serverBaseURL = "http://127.0.0.1:8000" //*"http://192.168.1.5:8000"           /*/

class NetworkConfig: NSObject {
    static var baseURL: String { serverBaseURL }
    static var token: String?
    static let contentType = "application/json"
    static let timeout = 3.0
    
    static func authorization() -> String? {
        guard let token = token, !token.isEmpty else {
            return nil
        }
        return "Bearer \(token)"
    }
    
    static var headers: HTTPHeaders {
        var headers = ["Content-Type": contentType]
        if let auth = authorization() {
            headers["Authorization"] = auth
        }
        return HTTPHeaders(headers)
    }
    
    static var errorStatusCodes: [Int] {
        return [400, 401, 404, 500]
    }
    
    static var acceptableStatusCodes: [Int] {
        var codes = Array(200..<300)
        codes.append(contentsOf: errorStatusCodes)
        return codes
    }
    
}
