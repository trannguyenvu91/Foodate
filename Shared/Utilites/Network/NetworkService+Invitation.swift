//
//  NetworkService+Invitation.swift
//  Foodate
//
//  Created by Vu Tran on 27/07/2021.
//

import Foundation
import Combine

extension NetworkService {
    
    class func getInvitation(ID: Int) -> NetworkPublisher<FDInvitation> {
        return NetworkResource(method: .get,
                               params: nil,
                               api: "/api/v1/invitations/\(ID)/")
            .requestPubliser()
            .tryImportObject()
    }
    
    class func deleteInvitation(ID: Int) -> NetworkPublisher<FDInvitation> {
        return NetworkResource(method: .delete,
                               params: nil,
                               api: "/api/v1/invitations/\(ID)/")
            .requestPubliser()
            .tryImportObject()
    }
    
    class func updateInvitation(ID: Int, parameters: JSON) -> NetworkPublisher<FDInvitation> {
        return NetworkResource(method: .put,
                               params: parameters,
                               api: "/api/v1/invitations/\(ID)/")
            .requestPubliser()
            .tryImportObject()
    }
    
    class func replyInvitation(ID: Int, state: FDInvitationState) -> NetworkPublisher<FDInvitation> {
        return NetworkResource(method: .post,
                               params: ["state": state.rawValue],
                               api: "/api/v1/invitations/\(ID)/reply/")
            .requestPubliser()
            .tryImportObject()
    }
    
    class func createInvitation(parameters: JSON) -> NetworkPublisher<FDInvitation> {
        return NetworkResource(method: .post,
                               params: parameters,
                               api: "/api/v1/invitations/")
            .requestPubliser()
            .tryImportObject()
    }
    
}
