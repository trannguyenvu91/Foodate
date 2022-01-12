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
    
    @MainActor
    static var shared: NetworkService {
        get {
            if let sharedInstance = sharedInstance {
                return sharedInstance
            }
            let instance = NetworkService()
            sharedInstance = instance
            return instance
        }
        set {
            sharedInstance = newValue
        }
    }
    
    private static var sharedInstance: NetworkService?
    private lazy var actor: NetworkActor = NetworkActor(session)
    private lazy var session: Session = Session(configuration: self.config)
    private let config: URLSessionConfiguration = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = NetworkConfig.timeout
        return config
    }()
    
    @MainActor
    func request(url: String,
                       method: HTTPMethod,
                       parameters: JSON?,
                       headers: HTTPHeaders = NetworkConfig.headers) async throws -> JSON {
        return try await actor.request(url: url, method: method, parameters: parameters, headers: headers)
    }
    
}

private actor NetworkActor {
    
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
                .responseData(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        guard let json = try? JSONSerialization.jsonObject(with: value, options: .fragmentsAllowed) as? JSON else {
                            continuation.resume(throwing: NetworkError.invalidJSONFormat)
                            return
                        }
                        if let error = self.validateError(code: response.response?.statusCode,
                                                          info: json) {
                            continuation.resume(throwing: error)
                            return
                        }
                        continuation.resume(returning: json)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                })
        })
    }
    
    func validateError(code: Int?, info: JSON) -> NetworkError? {
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

