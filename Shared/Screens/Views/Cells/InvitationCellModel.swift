//
//  InvitationCellModel.swift
//  Foodate
//
//  Created by Vu Tran on 22/07/2021.
//

import Foundation
import CoreStore
import Combine

class InvitationCellModel: ObjectBaseViewModel<FDInvitation> {
    let sendRequest = PassthroughSubject<Bool, Never>()
    let inviteFriend = PassthroughSubject<Any, Never>()
    let reply = PassthroughSubject<FDInvitationState, Never>()
    
    override init() {
        super.init()
        bindSendRequest()
        bindReply()
        bindInviteCommand()
    }
    
    func bindSendRequest() {
        let publisher = sendRequest.flatMap({ [unowned self] in
            $0 ? NetworkService.createRequest(for: self.objectPubliser.id!) : NetworkService.deleteRequest(for: self.objectPubliser.id!)
        }).eraseToAnyPublisher()
        execute(publisher: publisher)
    }
    
    func bindReply() {
        let publisher = reply.flatMap({ [unowned self] in
            NetworkService.replyInvitation(ID: self.objectPubliser.id!, state: $0)
        }).eraseToAnyPublisher()
        execute(publisher: publisher)
    }
    
    func bindInviteCommand() {
        inviteFriend.sink { [unowned self] user in
            guard let user = user as? ObjectPublisher<FDUserProfile> else {
                return
            }
            let updates = ["to_user": ["id": user.id ?? 0]]
            
            let publisher = NetworkService.updateInvitation(ID: objectPubliser.id ?? 0,
                                                            parameters: updates)
                .eraseToAnyPublisher()
            execute(publisher: publisher)
        }
        .store(in: &cancelableSet)
    }
    
}
