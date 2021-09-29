//
//  NetworkService+Invitation.swift
//  Foodate
//
//  Created by Vu Tran on 27/07/2021.
//

import Foundation

extension NetworkService {
    
    class func getInvitation(ID: Int) async throws -> FDInvitation {
        try await NetworkResource(method: .get,
                                  params: nil,
                                  api: "/api/v1/invitations/\(ID)/")
            .request()
    }
    
    class func deleteInvitation(ID: Int) async throws -> FDInvitation {
        try await NetworkResource(method: .delete,
                                  params: nil,
                                  api: "/api/v1/invitations/\(ID)/")
            .request()
    }
    
    class func updateInvitation(ID: Int, parameters: JSON) async throws -> FDInvitation {
        try await NetworkResource(method: .put,
                                  params: parameters,
                                  api: "/api/v1/invitations/\(ID)/")
            .request()
    }
    
    class func replyInvitation(ID: Int, state: FDInvitationState) async throws -> FDInvitation {
        try await NetworkResource(method: .post,
                                  params: ["state": state.rawValue],
                                  api: "/api/v1/invitations/\(ID)/reply/")
            .request()
    }
    
    class func createInvitation(parameters: JSON) async throws -> FDInvitation {
        try await NetworkResource(method: .post,
                                  params: parameters,
                                  api: "/api/v1/invitations/")
            .request()
    }
    
}
