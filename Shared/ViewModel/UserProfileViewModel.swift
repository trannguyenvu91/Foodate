//
//  UserProfileViewModel.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import Combine
import CoreStore

class UserProfileViewModel: BaseObjectViewModel<FDUserProfile>, ListViewModel {
    
    lazy var paginator: Paginator<FDInvitation> = {
        InvitationPaginator(userID: objectID, type: .events)
    }()
    
    override func initialSetup() {
        super.initialSetup()
        observeNewInvitation()
    }
    
    @MainActor
    func refresh() async {
        do {
            try await loadObject()
            try await paginator.refresh()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
}

extension UserProfileViewModel: InvitationObservable {
    var observedPaginator: Paginator<FDInvitation> {
        paginator
    }
    
    func shouldInsert(_ invitation: FDInvitation) -> Bool {
        guard let snapshot = invitation.asSnapshot(in: .defaultStack) else {
            return false
        }
        if snapshot.$owner?.isSession == true, LibraryAPI.shared.userSnapshot?.$id == objectID {
            return true
        } else if snapshot.$toUser?.$id == objectID {
            return true
        }
        return false
    }
    
}
