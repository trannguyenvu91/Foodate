//
//  NetworkService+Request.swift
//  Foodate
//
//  Created by Vu Tran on 27/07/2021.
//

import Foundation

extension NetworkService {
    
    func createRequest(for invitationID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(invitationID)/requests/",
                          method: .post,
                          parameters: nil)
    }
    
    
    func deleteRequest(for invitationID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(invitationID)/requests/0/",
                          method: .delete,
                          parameters: nil)
    }
    
    func acceptRequest(for invitationID: Int, requestID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(invitationID)/requests/\(requestID)/accept/",
                          method: .post,
                          parameters: nil)
    }
    
}
