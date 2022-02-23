//
//  InvitationViewModel.swift
//  Foodate
//
//  Created by Vu Tran on 12/22/21.
//

import Foundation
import Combine
import CoreStore

class InvitationViewModel: BaseObjectViewModel<FDInvitation> {
    lazy var paginator: Paginator<FDRequester> = {
        RequestPaginator(objectID)
    }()
    
    func accept(_ requester: ObjectSnapshot<FDRequester>) async throws {
        let invitation = try await LibraryAPI.shared.acceptRequest(for: objectID,
                                                          requestID: requester.$requestID)
        viewDismissalModePublisher.send(true)
        if let snapshot = invitation.asSnapshot(in: .defaultStack) {
            AppFlow.shared.presentScreen = .matched(snapshot)
        }
    }
    
    var canViewRequests: Bool {
        snapshot?.$owner?.asSnapshot(in: .defaultStack)?.isSession == true &&
        snapshot?.$state == .pending
    }
    
    var isArchivedInvitation: Bool {
        if let endAt = snapshot?.$endAt, endAt < Date.now {
            return true
        }
        return false
    }
    
    func refresh() async {
        do {
            try await loadObject()
            if canViewRequests {
                try await paginator.refresh()
            }
        } catch {
            self.error = error
        }
    }
    
}
