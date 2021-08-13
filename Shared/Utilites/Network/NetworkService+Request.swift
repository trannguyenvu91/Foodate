//
//  NetworkService+Request.swift
//  Foodate
//
//  Created by Vu Tran on 27/07/2021.
//

import Foundation
import Combine

extension NetworkService {
    
    class func createRequest(for invitationID: Int) -> NetworkPublisher<FDInvitation> {
        return NetworkResource(method: .post,
                               params: nil,
                               api: "/api/v1/invitations/\(invitationID)/requests/")
            .requestPubliser()
            .tryImportObject()
    }
    
    
    class func deleteRequest(for invitationID: Int) -> NetworkPublisher<FDInvitation> {
        return NetworkResource(method: .delete,
                               params: nil,
                               api: "/api/v1/invitations/\(invitationID)/requests/0/")
            .requestPubliser()
            .tryImportObject()
    }
    
    class func acceptRequest(for invitationID: Int, requestID: Int) -> NetworkPublisher<FDInvitation> {
        return NetworkResource(method: .post,
                               params: nil,
                               api: "/api/v1/invitations/\(invitationID)/requests/\(requestID)/accept/")
            .requestPubliser()
            .tryImportObject()
    }
    
}
