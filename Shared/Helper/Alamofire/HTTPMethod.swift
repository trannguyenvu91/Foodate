//
//  HTTPMethod.swift
//  Foodate
//
//  Created by Vu Tran on 12/8/21.
//

import Alamofire

extension HTTPMethod {
    
    var encoding: ParameterEncoding {
        if self == .get {
            return URLEncoding.queryString
        }
        return JSONEncoding.default
    }
    
}
