//
//  LibraryAPI.swift
//  Foodate
//
//  Created by Vu Tran on 2/14/22.
//

import Foundation
import CoreStore
import CoreLocation

class LibraryAPI: NSObject {
    
    static let shared = LibraryAPI()
    private let database = FDCoreStore()
    private let network = NetworkService(.standard)
    
    var sessionUser: ObjectSnapshot<FDSessionUser>? {
        didSet {
            NetworkConfig.token = sessionUser?.$token
        }
    }
    
}

//MARK: Data
extension LibraryAPI {
    
    //MARK: User
    func login(username: String, password: String) async throws -> FDSessionUser  {
        try await network.login(username: username, password: password)
    }
    
    func register(username: String,
                  password: String,
                  email: String) async throws -> FDSessionUser {
        try await network.register(username: username, password: password, email: email)
    }
    
    func reset(username: String,
               password: String) async throws -> FDSessionUser {
        try await network.reset(username: username, password: password)
    }
    
    func updateUser(ID: Int, parameters: JSON) async throws -> FDUserProfile {
        try await network.updateUser(ID: ID, parameters: parameters)
    }
    
    func getUser(ID: Int) async throws -> FDUserProfile {
        //TODO: I'm thinking about fetch local data and update it remotely?
        try await network.getUser(ID: ID)
    }
    
    //MARK: Invitation
    func getInvitation(ID: Int) async throws -> FDInvitation {
        try await network.getInvitation(ID: ID)
    }
    
    func deleteInvitation(ID: Int) async throws -> FDInvitation {
        try await network.deleteInvitation(ID: ID)
    }
    
    func updateInvitation(ID: Int, parameters: JSON) async throws -> FDInvitation {
        try await network.updateInvitation(ID: ID, parameters: parameters)
    }
    
    func replyInvitation(ID: Int, state: InvitationState) async throws -> FDInvitation {
        try await network.replyInvitation(ID: ID, state: state)
    }
    
    func createInvitation(parameters: JSON) async throws -> FDInvitation {
        try await network.createInvitation(parameters: parameters)
    }
    
    //MARK: Request
    func createRequest(for invitationID: Int) async throws -> FDInvitation {
        try await network.createRequest(for: invitationID)
    }
    
    
    func deleteRequest(for invitationID: Int) async throws -> FDInvitation {
        try await network.deleteRequest(for: invitationID)
    }
    
    func acceptRequest(for invitationID: Int, requestID: Int) async throws -> FDInvitation {
        try await network.acceptRequest(for: invitationID, requestID: requestID)
    }
    
    //MARK: Place
    func getPlace(ID: String) async throws -> FDPlace {
        try await network.getPlace(ID: ID)
    }
    
}
