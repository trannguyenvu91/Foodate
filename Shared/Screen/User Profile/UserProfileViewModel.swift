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
    
    func refresh() async {
        do {
            try await loadObject()
            try await paginator.refresh()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
    override func fetchLocalObject() throws -> ObjectPublisher<FDUserProfile>? {
        if let local = try super.fetchLocalObject() {
            return local
        }
        if let user = try FDCoreStore.shared.fetchOne(
            Where<FDUser>(FDUser.uniqueIDKeyPath, isEqualTo: objectID)
        )?
            .asSnapshot(in: .defaultStack) {
            return try user.userProfile.asPublisher(in: .defaultStack)
        }
        if let user = try FDCoreStore.shared.fetchOne(
            Where<FDBaseUser>(FDUser.uniqueIDKeyPath, isEqualTo: objectID)
        )?
            .asSnapshot(in: .defaultStack) {
            return try user.userProfile.asPublisher(in: .defaultStack)
        }
        return nil
    }
    
}
