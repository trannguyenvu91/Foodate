//
//  UserProfileViewModel.swift
//  Foodate (iOS)
//
//  Created by Vu Tran on 15/07/2021.
//

import Foundation
import Combine
import CoreStore

class UserProfileViewModel: ObjectBaseViewModel<FDUserProfile>, ListViewModel {
    
    var paginator: Paginator<FDInvitation>
    
    override init(_ user: ObjectPublisher<FDUserProfile>) {
        self.paginator = InvitationPaginator.paginator(userID: user.id!, type: .events)
        super.init(user)
    }
    
    var invitations: [ObjectPublisher<FDInvitation>] {
        paginator.items.compactMap({ $0.asPublisher(in: .defaultStack) })
    }
    
    func refresh() async {
        do {
            try await getProfile()
            try await paginator.refresh()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
    }
    
    func getProfile() async throws {
        guard let id = objectPublisher.id else {
            return
        }
        let _ = try await NetworkService.getUser(ID: id)
        self.objectWillChange.send()
    }
}
