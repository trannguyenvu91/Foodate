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
        guard let id = objectPubliser.id else {
            return
        }
        do {
            let _ = try await NetworkService.getUser(ID: id)
            try await paginator.refresh()
            self.objectWillChange.send()
        } catch {
            self.error = error
        }
        
    }
}
