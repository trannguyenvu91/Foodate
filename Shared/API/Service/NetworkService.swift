//
//  NetworkService.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/14/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidAPI(String?)
    case invalidStatusCode(Int, String)
    case invalidJSONFormat
}

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

extension ServiceActor where Self == NetworkActor {
    static var standard: Self {
        NetworkActor(.standard)
    }
}

actor NetworkActor: ServiceActor {
    
    private(set) var session: Session
    private var validCodes: [Int]
    private var errorCodes: [Int]
    
    init(_ session: Session,
         validCodes: [Int] = Array(200..<300),
         errorCodes: [Int] = [400, 401, 404, 500]) {
        self.session = session
        self.validCodes = validCodes
        self.errorCodes = errorCodes
    }
    
    func request(url: String,
                 method: HTTPMethod,
                 parameters: JSON?,
                 headers: HTTPHeaders? = nil) async throws -> JSON {
        try await withCheckedThrowingContinuation({ continuation in
            let _ = session.request(url,
                                    method: method,
                                    parameters: parameters,
                                    encoding: method.encoding,
                                    headers: headers)
                .validate(statusCode: acceptableCodes)
                .responseData(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        guard let json = try? JSONSerialization.jsonObject(with: value,
                                                                           options: .fragmentsAllowed) as? JSON else {
                            continuation.resume(throwing: NetworkError.invalidJSONFormat)
                            return
                        }
                        if let error = self.checkError(response.response,
                                                       json: json) {
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
    
    internal func checkError(_ response: HTTPURLResponse?, json: JSON) -> NetworkError? {
        guard let code = response?.statusCode,
              errorCodes.contains(code) else {
                  return nil
              }
        let message = json["detail"] as? String ?? json.reduce("", { (message, arg1) in
            let (key, value) = arg1
            return message + "\(key): \(value) "
        })
        return .invalidStatusCode(code, message)
    }
    
    internal var acceptableCodes: [Int] {
        validCodes + errorCodes
    }
    
}
