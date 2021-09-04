//
//  NetworkService.swift
//  ArtBoard
//
//  Created by Vu Tran on 12/14/19.
//  Copyright © 2019 Vu Tran. All rights reserved.
//

import Foundation
import Alamofire
import Combine

typealias FailureBlock = (Error) -> Void
typealias SuccessBlock<T> = (T) -> Void
typealias CompletionBlock = () -> Void
typealias JSONPublisher = Future<JSON, Error>
typealias NetworkPublisher<T> = AnyPublisher<T, Error>

class NetworkService: NSObject {
    
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
    
    class func requestPubliser(url: String,
                               method: HTTPMethod,
                               parameters: JSON?,
                               headers: HTTPHeaders = NetworkConfig.headers) -> JSONPublisher {
        return JSONPublisher { (handler) in
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
                            handler(.failure(error))
                            return
                        }
                        handler(.success(value as! JSON))
                    case .failure(let error):
                        handler(.failure(error))
                    }
            }
        }
    }
    
    static var errorStatusCodes: [Int] {
        return [400, 401, 404]
    }
    
    static var acceptableStatusCodes: [Int] {
        var codes = Array(200..<300)
        codes.append(contentsOf: errorStatusCodes)
        return codes
    }
    
    class func validateError(code: Int?, info: Any) -> NetworkError? {
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
    
}

extension HTTPMethod {
    
    var encoding: ParameterEncoding {
        if self == .get {
            return URLEncoding.queryString
        }
        return JSONEncoding.default
    }
    
}

extension JSONPublisher {
    func tryImportObject<T>() -> NetworkPublisher<T> where T: ImportableJSONObject {
        tryMap({ try T.importObject(from: $0) }).eraseToAnyPublisher()
    }
}
