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
    
    init(_ user: ObjectPublisher<FDUserProfile>) {
        self.paginator = InvitationPaginator.paginator(userID: user.id!)
        super.init()
        self.objectPubliser = user
    }
    
    var invitations: [ObjectPublisher<FDInvitation>] {
        paginator.items.compactMap({ $0.asPublisher(in: .defaultStack) })
    }
    
    func refresh() async throws {
        guard let id = objectPubliser.id else {
            return
        }
        let _ = try await NetworkService.getUser(ID: id)
        try await paginator.refresh()
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}
