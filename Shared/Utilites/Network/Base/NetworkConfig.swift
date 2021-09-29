//
//  NetworkConfig.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/14/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Alamofire

let serverBaseURL = "http://192.168.1.5:8000/"

class NetworkConfig: NSObject {
    static var baseURL: String { serverBaseURL }
    static var token: String?
    static let contentType = "application/json"
    
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
    
}
