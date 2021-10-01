//
//  NetworkService.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/14/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService: NSObject {
    
    private actor ServiceActor {
        
        var errorStatusCodes: [Int] {
            return [400, 401, 404]
        }
        
        var acceptableStatusCodes: [Int] {
            var codes = Array(200..<300)
            codes.append(contentsOf: errorStatusCodes)
            return codes
        }
        
        func validateError(code: Int?, info: Any) -> NetworkError? {
            guard let info = info as? JSON else {
                return NetworkError(code: 400, message: "The response is not JSON")
            }
            guard let code = code,
                  errorStatusCodes.contains(code) else {
                      return nil
                  }
            let message = info["detail"] as? String ?? info.reduce("", { (message, arg1) in
                let (key, value) = arg1
                return message + "\(key): \(value) "
            })
            return NetworkError(code: code, message: message)
        }
        
        func request(url: String,
                           method: HTTPMethod,
                           parameters: JSON?,
                           headers: HTTPHeaders = NetworkConfig.headers) async throws -> JSON {
            return try await withCheckedThrowingContinuation({ continuation in
                let _ = AF.request(url,
                                   method: method,
                                   parameters: parameters,
                                   encoding: method.encoding,
                                   headers: headers)
                    .validate(statusCode: self.acceptableStatusCodes)
                    .responseJSON { (response) in
                        switch response.result {
                        case .success(let value):
                            if let error = self.validateError(code: response.response?.statusCode,
                                                              info: value) {
                                continuation.resume(throwing: error)
                                return
                            }
                            continuation.resume(returning: value as! JSON)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
            })
        }
    }
    
    static private let actor = ServiceActor()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.standard)
        return decoder
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.standard)
        return encoder
    }()
    
    @MainActor
    class func request(url: String,
                       method: HTTPMethod,
                       parameters: JSON?,
                       headers: HTTPHeaders = NetworkConfig.headers) async throws -> JSON {
        return try await actor.request(url: url, method: method, parameters: parameters, headers: headers)
    }
    
}

extension HTTPMethod {
    
    var encoding: ParameterEncoding {
        if self == .get {
            return URLEncoding.queryString
        }
        return JSONEncoding.default
    }
    
}
