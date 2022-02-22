//
//  NetworkError.swift
//  Foodate
//
//  Created by Vu Tran on 12/8/21.
//

import Foundation

struct NetworkError: Error {
    let code: Int
    let message: String
    
    init(code: Int, message: String?) {
        self.code = code
        self.message = message ?? "NetworkError_Operation_Error_Alert".localized()
    }
    
}

extension NetworkError {
    
    static var invalidJSONFormat: NetworkError {
        NetworkError(code: 400, message: "NetworkError_JSON_Error_Alert".localized())
    }
    
}
