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
    let inviteFriend = PassthroughSubject<Any, Never>()
    
    override init(_ invitation: ObjectPublisher<FDInvitation>) {
        super.init(invitation)
        bindInviteCommand()
    }
    
    func sendRequest(_ isSending: Bool) async throws {
        let id = self.objectPublisher.id!
        let _ = isSending ? try await NetworkService.createRequest(for: id) : try await NetworkService.deleteRequest(for: id)
    }
    
    func reply(_ state: InvitationState) async throws {
        let id = self.objectPublisher.id!
        let _ = try await NetworkService.replyInvitation(ID: id, state: state)
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
