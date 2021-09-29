//
//  NetworkService+User.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation

//MARK: Authentication
extension NetworkService {
    
    class func login(username: String,
                     password: String) async throws -> FDSessionUser {
        try await NetworkResource(method: .post,
                                  params: ["username": username.lowercased(), "password": password],
                                  api: "/api/v1/auth/login")
            .request()
    }
    
    class func register(@Lowercased username: String,
                        password: String,
                        @Lowercased email: String) async throws -> FDSessionUser {
        let _ = try await NetworkResource<JSON>(method: .post,
                                                params: ["username": username, "password": password, "email": email],
                                                api: "/api/v1/auth/register")
            .request()
        return try await login(username: username, password: password)
    }
    
}

//MARK: Profile
extension NetworkService {
    
    class func updateUser(ID: Int, parameters: JSON) async throws -> FDUserProfile {
        try await NetworkResource(method: .patch,
                                  params: parameters,
                                  api: "/api/v1/users/\(ID)/")
            .request()
    }
    
    class func getUser(ID: Int) async throws -> FDUserProfile {
        try await NetworkResource(method: .get,
                                  params: nil,
                                  api: "/api/v1/users/\(ID)/")
            .request()
    }
    
}
