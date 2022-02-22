//
//  NetworkService+User.swift
//  Foodate
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation

//MARK: Authentication
extension NetworkService {
    
    func login(@Lowercased username: String,
                     password: String) async throws -> FDSessionUser {
        try await request(api: "/api/v1/auth/login",
                          method: .post,
                          parameters: ["username": username.lowercased(), "password": password])
    }
    
    func register(@Lowercased username: String,
                        password: String,
                        @Lowercased email: String) async throws -> FDSessionUser {
        let _: JSON = try await request(api: "/api/v1/auth/register",
                                  method: .post,
                                  parameters: ["username": username, "password": password, "email": email])
        return try await login(username: username, password: password)
    }
    
    func reset(@Lowercased username: String,
                        password: String) async throws -> FDSessionUser {
        let _: JSON = try await request(api: "/api/v1/auth/reset",
                                  method: .post,
                                  parameters: ["username": username, "password": password])
        return try await login(username: username, password: password)
    }
    
}

//MARK: Profile
extension NetworkService {
    
    func updateUser(ID: Int, parameters: JSON) async throws -> FDUserProfile {
        try await request(api: "/api/v1/users/\(ID)/",
                          method: .patch,
                          parameters: parameters)
    }
    
    func getUser(ID: Int) async throws -> FDUserProfile {
        try await request(api: "/api/v1/users/\(ID)/",
                                  method: .get,
                                  parameters: nil)
    }
    
}
