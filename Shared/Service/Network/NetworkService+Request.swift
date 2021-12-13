//
//  NetworkService+Request.swift
//  Foodate
//
//  Created by Vu Tran on 27/07/2021.
//

import Foundation

extension NetworkService {
    
    class func createRequest(for invitationID: Int) async throws -> FDInvitation {
        try await NetworkResource(method: .post,
                                  params: nil,
                                  api: "/api/v1/invitations/\(invitationID)/requests/")
            .request()
    }
    
    
    class func deleteRequest(for invitationID: Int) async throws -> FDInvitation {
        try await NetworkResource(method: .delete,
                                  params: nil,
                                  api: "/api/v1/invitations/\(invitationID)/requests/0/")
            .request()
    }
    
    class func acceptRequest(for invitationID: Int, requestID: Int) async throws -> FDInvitation {
        try await NetworkResource(method: .post,
                                  params: nil,
                                  api: "/api/v1/invitations/\(invitationID)/requests/\(requestID)/accept/")
            .request()
    }
    
}
