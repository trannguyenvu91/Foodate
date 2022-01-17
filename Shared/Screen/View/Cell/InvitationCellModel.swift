//
//  InvitationCellModel.swift
//  Foodate
//
//  Created by Vu Tran on 22/07/2021.
//

import Foundation
import CoreStore
import Combine

class InvitationCellModel: BaseObjectViewModel<FDInvitation> {
    let inviteFriend = PassthroughSubject<Any, Never>()
    
    override init(_ invitation: ObjectPublisher<FDInvitation>) {
        super.init(invitation)
        bindInviteCommand()
    }
    
    func sendRequest(_ isSending: Bool) async throws {
        let _ = isSending ? try await NetworkService.createRequest(for: objectID) : try await NetworkService.deleteRequest(for: objectID)
    }
    
    func reply(_ state: InvitationState) async throws {
        let invitation = try await NetworkService.replyInvitation(ID: objectID, state: state)
        if let snapshot = invitation.asSnapshot(in: .defaultStack), snapshot.$state == .matched {
            AppConfig.shared.presentScreen = .matched(snapshot)
        }
    }
    
    func bindInviteCommand() {
        inviteFriend.sink { [unowned self] user in
            guard let user = user as? ObjectSnapshot<FDUserProfile> else {
                return
            }
            let updates = ["to_user": ["id": user.$id]]
            asyncDo {
                let _ = try await NetworkService.updateInvitation(ID: objectID,
                                                          parameters: updates)
            }
        }
        .store(in: &cancelableSet)
    }
    
}
