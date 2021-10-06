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
    
    override init(_ invitation: ObjectPublisher<FDInvitation>) {
        super.init(invitation)
        bindSendRequest()
        bindReply()
        bindInviteCommand()
    }
    
    func bindSendRequest() {
        sendRequest.sink { [unowned self] isSending in
            let id = self.objectPubliser.id!
            asyncDo {
                let _ = isSending ? try await NetworkService.createRequest(for: id) : try await NetworkService.deleteRequest(for: id)
            }
        }
        .store(in: &cancelableSet)
    }
    
    func bindReply() {
        reply.sink{ [unowned self] state in
            asyncDo {
                let _ = try await NetworkService.replyInvitation(ID: objectPubliser.id!, state: state)
            }
        }
            .store(in: &cancelableSet)
    }
    
    func bindInviteCommand() {
        inviteFriend.sink { [unowned self] user in
            guard let user = user as? ObjectSnapshot<FDUserProfile> else {
                return
            }
            let updates = ["to_user": ["id": user.$id]]
            asyncDo {
                let _ = try await NetworkService.updateInvitation(ID: objectSnapshot.$id,
                                                          parameters: updates)
            }
        }
        .store(in: &cancelableSet)
    }
    
}
