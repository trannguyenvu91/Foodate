//
//  HTTPMethod.swift
//  Foodate
//
//  Created by Vu Tran on 12/8/21.
//

import Alamofire
import Foundation

extension HTTPMethod {
    
    var encoding: ParameterEncoding {
        if self == .get {
            return URLEncoding.queryString
        }
        return JSONEncoding.default
    }
    
}

extension Session {
    static var standard: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = NetworkConfig.timeout
        return Session(configuration: config)
    }()
}
