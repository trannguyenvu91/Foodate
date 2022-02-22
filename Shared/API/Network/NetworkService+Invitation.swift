//
//  NetworkService+Invitation.swift
//  Foodate
//
//  Created by Vu Tran on 27/07/2021.
//

import Foundation

extension NetworkService {
    
    func getInvitation(ID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(ID)/",
                          method: .get,
                          parameters: nil)
    }
    
    func deleteInvitation(ID: Int) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(ID)/",
                          method: .delete,
                          parameters: nil)
    }
    
    func updateInvitation(ID: Int, parameters: JSON) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(ID)/",
                          method: .put,
                          parameters: parameters)
    }
    
    func replyInvitation(ID: Int, state: InvitationState) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/\(ID)/reply/",
                          method: .post,
                          parameters: ["state": state.rawValue])
    }
    
    func createInvitation(parameters: JSON) async throws -> FDInvitation {
        try await request(api: "/api/v1/invitations/",
                          method: .post,
                          parameters: parameters)
    }
    
}
