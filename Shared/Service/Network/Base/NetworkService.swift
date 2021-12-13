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
    
    private var actor: ServiceActor
    var session: Session
    static let shared = NetworkService()
    
    override init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = NetworkConfig.timeout
        session = Session(configuration: config)
        actor = ServiceActor(session)
    }
    
    @MainActor
    class func request(url: String,
                       method: HTTPMethod,
                       parameters: JSON?,
                       headers: HTTPHeaders = NetworkConfig.headers) async throws -> JSON {
        return try await Self.shared.actor.request(url: url, method: method, parameters: parameters, headers: headers)
    }
    
}

private actor ServiceActor {
    
    var session: Session
    
    init(_ session: Session) {
        self.session = session
    }
    
    func request(url: String,
                       method: HTTPMethod,
                       parameters: JSON?,
                       headers: HTTPHeaders = NetworkConfig.headers) async throws -> JSON {
        return try await withCheckedThrowingContinuation({ continuation in
            let _ = session.request(url,
                               method: method,
                               parameters: parameters,
                               encoding: method.encoding,
                               headers: headers)
                .validate(statusCode: NetworkConfig.acceptableStatusCodes)
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
    
    func validateError(code: Int?, info: Any) -> NetworkError? {
        guard let info = info as? JSON else {
            return .invalidJSONFormat
        }
        guard let code = code,
              NetworkConfig.errorStatusCodes.contains(code) else {
                  return nil
              }
        let message = info["detail"] as? String ?? info.reduce("", { (message, arg1) in
            let (key, value) = arg1
            return message + "\(key): \(value) "
        })
        return NetworkError(code: code, message: message)
    }
    
}

