//
//  NetworkService+User.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import Combine

//MARK: Authentication
extension NetworkService {
    
    class func login(username: String,
                     password: String) -> NetworkPublisher<FDSessionUser> {
        return NetworkResource(method: .post,
                               params: ["username": username.lowercased(), "password": password],
                               api: "/api/v1/auth/login")
            .requestPubliser()
            .tryImportObject()
    }
    
    class func register(username: String,
                        password: String,
                        email: String) -> NetworkPublisher<FDSessionUser> {
        return NetworkResource(method: .post,
                               params: ["username": username.lowercased(), "password": password, "email": email.lowercased()],
                               api: "/api/v1/auth/register")
            .requestPubliser()
            .flatMap({ _ in NetworkService.login(username: username, password: password) })
            .eraseToAnyPublisher()
    }
    
}

//MARK: Profile
extension NetworkService {
    
    class func updateUser(ID: Int, parameters: JSON) -> NetworkPublisher<FDUserProfile> {
        return NetworkResource(method: .put,
                               params: parameters,
                               api: "/api/v1/users/\(ID)/")
            .requestPubliser()
            .tryImportObject()
    }
    
    class func getUser(ID: Int) -> NetworkPublisher<FDUserProfile> {
        return NetworkResource(method: .get,
                               params: nil,
                               api: "/api/v1/users/\(ID)/")
            .requestPubliser()
            .tryImportObject()
    }
    
}
