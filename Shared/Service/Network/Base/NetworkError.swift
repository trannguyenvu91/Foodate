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
        self.message = message ?? "The operation couldn't be completed. Please try again."
    }
    
}

extension NetworkError {
    
    static var invalidJSONFormat: NetworkError {
        NetworkError(code: 400, message: "The response is not JSON")
    }
    
}
